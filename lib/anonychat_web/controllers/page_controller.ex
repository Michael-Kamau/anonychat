defmodule AnonychatWeb.PageController do
  use AnonychatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
