defmodule HyperionWeb.PingController do
  use HyperionWeb, :controller

  def ping(conn, _params) do
    render(conn, :ping)
  end
end
