defmodule AnonychatWeb.PageController do
  use AnonychatWeb, :controller

  # def home(conn, _params) do
  #   render(conn, :home)
  # end

  def home(conn, _params) do
    # :timer.sleep(1000)
    conn
    |> assign_prop(:name, "Phoenix + Inertia + Vues 🚀")
    |> render_inertia("Home")    # "Home" will resolve to assets/js/pages/Home.vue
  end


   def about(conn, _params) do
    :timer.sleep(1000)
    conn
    |> assign_prop(:name, "Phoenix + Inertia + Vues 🚀")
    |> render_inertia("About")    # "Home" will resolve to assets/js/pages/Home.vue
  end
end
