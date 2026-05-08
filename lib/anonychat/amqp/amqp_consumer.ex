defmodule Anonychat.Amqp.AmqpConsumer do
  use GenServer
  use AMQP

  require Logger

  @retry_interval 10_000

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], [])
  end

  @exchange "gen_server_test_exchange"
  @queue "gen_server_test_queue"
  @queue_error "#{@queue}_error"

  def init(_opts) do
    {:ok, %{channel: nil, failures: 0}, {:continue, :connect}}
  end

  def handle_continue(:connect, state) do
    connect(state)
  end

  def handle_info(:connect, state) do
    connect(state)
  end

  defp connect(state) do
    with {:ok, conn} <- Connection.open(amqp_connection_config()),
         {:ok, chan} <- Channel.open(conn),
         :ok <- setup_queue(chan),
         :ok <- Basic.qos(chan, prefetch_count: 10),
         {:ok, _consumer_tag} <- Basic.consume(chan, @queue) do
      Logger.info("AMQP consumer connected")
      {:noreply, %{state | channel: chan}}
    else
      {:error, reason} ->
        log_connection_failure(state.failures, reason)
        schedule_reconnect()
        {:noreply, %{state | channel: nil, failures: state.failures + 1}}
    end
  end

  defp amqp_connection_config do
    amqp_config = Application.fetch_env!(:anonychat, :amqp)
    connections = Keyword.get(amqp_config, :connections, [])
    [queue_chat | _] = connections

    case queue_chat do
      %{host: _, port: _, username: _, password: _} = conn ->
        Enum.into(conn, [])

      {:chat_conn, conn} when is_list(conn) ->
        conn
    end
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, state) do
    {:noreply, state}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, state) do
    schedule_reconnect()
    {:noreply, %{state | channel: nil}}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, state) do
    {:noreply, state}
  end

  def handle_info(
        {:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}},
        %{channel: chan} = state
      ) do
    # You might want to run payload consumption in separate Tasks in production
    consume(chan, tag, redelivered, payload)
    {:noreply, state}
  end

  defp setup_queue(chan) do
    {:ok, _} = Queue.declare(chan, @queue_error, durable: true)

    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    {:ok, _} =
      Queue.declare(chan, @queue,
        durable: true,
        arguments: [
          {"x-dead-letter-exchange", :longstr, ""},
          {"x-dead-letter-routing-key", :longstr, @queue_error}
        ]
      )

    :ok = Exchange.fanout(chan, @exchange, durable: true)
    :ok = Queue.bind(chan, @queue, @exchange)
  end

  defp consume(channel, tag, redelivered, payload) do
    binary_string = payload |> to_string() |> String.trim()

    if is_binary(binary_string) do
      :ok = Basic.ack(channel, tag)

      AnonychatWeb.Endpoint.broadcast(
        "amqp:user_messages",
        "new_message",
        %{body: binary_string, created_at: DateTime.utc_now() |> DateTime.to_iso8601()}
      )
    else
      :ok = Basic.reject(channel, tag, requeue: false)
      IO.puts("#{binary_string} is not a valid binary string and was rejected.")
    end
  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise consumer will stop
    # receiving messages.
    _exception ->
      :ok = Basic.reject(channel, tag, requeue: not redelivered)
      IO.puts("Error converting #{payload} to integer")
  end

  defp schedule_reconnect do
    Process.send_after(self(), :connect, @retry_interval)
  end

  defp log_connection_failure(0, reason) do
    Logger.warning("AMQP consumer connection failed: #{inspect(reason)}")
  end

  defp log_connection_failure(failures, reason) when rem(failures, 6) == 0 do
    Logger.warning("AMQP consumer still waiting for RabbitMQ: #{inspect(reason)}")
  end

  defp log_connection_failure(_failures, reason) do
    Logger.debug("AMQP consumer connection failed: #{inspect(reason)}")
  end
end
