defmodule AnonychatWeb.QueueController do
  use AnonychatWeb, :controller
  alias Anonychat.Amqp.AmqpPublisher

  def index(conn, _params) do
    conn
    |> assign_prop(:name, "Phoenix + Inertia + Vues 🚀")
    # "Home" will resolve to assets/js/pages/Home.vue
    |> render_inertia("Queue/Queue")
  end

  def create_message(conn, %{"message" => message} = _params) do
    message = String.trim(message || "")

    case message do
      "" ->
        IO.inspect("Empty message, not sending to queue.")

        conn
        |> put_flash(:error, "Message cannot be empty.")
        |> redirect(to: ~p"/queue")

      _ ->

        AmqpPublisher.publish(message)

      #   AnonychatWeb.Endpoint.broadcast(
      #   "amqp:user_messages",
      #   "new_message",
      #   %{body: message, created_at: DateTime.utc_now() |> DateTime.to_iso8601()}
      # )

        conn
        |> put_flash(:success, "Message sent to queue successfully!")
        |> redirect(to: ~p"/queue")
    end
  end
end
