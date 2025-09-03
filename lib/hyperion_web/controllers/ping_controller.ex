defmodule HyperionWeb.PingController do
  use HyperionWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

