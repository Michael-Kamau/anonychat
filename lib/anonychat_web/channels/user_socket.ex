defmodule AnonychatWeb.UserSocket do
  use Phoenix.Socket

  channel "room:*", AnonychatWeb.RoomChannel
  channel "amqp:*", AnonychatWeb.AmqpChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
