defmodule AnonychatWeb.AmqpChannel do
  use Phoenix.Channel

  def join("amqp:user_messages", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_message", %{"body" => body}, socket) do
    broadcast!(socket, "new_message", %{body: body})
    {:noreply, socket}
  end
end
