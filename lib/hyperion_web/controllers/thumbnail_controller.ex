defmodule HyperionWeb.ThumbnailController do
  use HyperionWeb, :controller

  alias Hyperion.Videos.Thumbnails

  def show(conn, %{"id" => id}) do
    case Thumbnails.get_thumbnail!(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> text("Not Found")

      %{data: data, content_type: content_type} ->
        conn
        |> put_resp_header("content-type", content_type)
        |> send_resp(:ok, data)
    end
  end
end
