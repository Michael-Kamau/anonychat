defmodule AnonychatWeb.QueueController do

  use AnonychatWeb, :controller

  def index(conn, _params) do

    conn
    |> assign_prop(:name, "Phoenix + Inertia + Vues 🚀")
    |> render_inertia("Queue/index")    # "Home" will resolve to assets/js/pages/Home.vue
  end

  def create_message(conn, %{"message"=> message} = _params ) do

    message = String.trim(message || "")

    case message do
      "" ->
        IO.inspect("Empty message, not sending to queue.")
        conn
        |> put_flash(:error, "Message cannot be empty.")
        |> redirect(to: ~p"/queue")
      _ ->

        IO.inspect("Sending message to queue.")

        conn
        |> put_flash(:success, "Message sent to queue successfully!")
        |> redirect(to: ~p"/queue")
    end

  end

end
