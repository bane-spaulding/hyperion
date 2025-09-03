defmodule HyperionWeb.PageController do
  use HyperionWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
