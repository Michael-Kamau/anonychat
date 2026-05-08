defmodule Anonychat.Amqp.AmqpPublisher do
  @moduledoc """
  Simple RabbitMQ publisher that uses the same connection as `AmqpConsumer`.
  """

  alias AMQP.{Basic, Channel, Connection}

  @exchange "gen_server_test_exchange"
  @routing_key ""

  @doc """
  Publish a message to the same exchange consumed by `AmqpConsumer`.
  """
  def publish(payload) when is_binary(payload) do
    do_publish_with_connection(amqp_connection_config(), @exchange, @routing_key, payload)
  end

  defp do_publish_with_connection(connection_config, exchange, routing_key, payload) do
    with {:ok, conn} <- Connection.open(connection_config) do
      try do
        with {:ok, chan} <- Channel.open(conn) do
          try do
            do_publish(chan, exchange, routing_key, payload)
          after
            close_if_open(chan)
          end
        end
      after
        close_if_open(conn)
      end
    end
  end

  defp amqp_connection_config do
    amqp_config = Application.fetch_env!(:anonychat, :amqp)
    connections = Keyword.get(amqp_config, :connections, [])
    [queue_chat | _] = connections

    case queue_chat do
      %{url: url} when is_binary(url) ->
        url

      %{host: _, port: _, username: _, password: _} = conn ->
        Enum.into(conn, [])

      {:chat_conn, [url: url]} when is_binary(url) ->
        url

      {:chat_conn, conn} when is_list(conn) ->
        conn
    end
  end

  defp do_publish(channel, exchange, routing_key, payload) do
    Basic.publish(
      channel,
      exchange,
      routing_key,
      payload,
      persistent: true,
      mandatory: false,
      immediate: false,
      content_type: "text/plain"
    )
  end

  defp close_if_open(%Channel{} = channel), do: Channel.close(channel)
  defp close_if_open(%Connection{} = conn), do: Connection.close(conn)
end
