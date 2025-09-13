defmodule HyperionWeb.ThumbnailController do
  use HyperionWeb, :controller

  alias Hyperion.Videos.Thumbnails

  def index(conn, _params) do
    thumbnails = Thumbnails.list_thumbnails()
    render(conn, "index.json", thumbnails: thumbnails)
  end

  def show(conn, %{"id" => id}) do
    video = Thumbnails.get_thumbnail!(id)
    render(conn, "show.json", video: video)
  end

  def create(
        conn,
        %{
          "thumbnail" => %{
            "file" => %Plug.Upload{} = file,
            "video_id" => video_id,
            "channel_id" => channel_id
          }
        }
      ) do
    with {:ok, thumbnail} <- Thumbnails.insert_thumbnail(file, video_id, channel_id) do
      conn
      |> put_status(:created)
      |> put_view(HyperionWeb.ThumbnailView)
      |> render("show.json", thumbnail: thumbnail)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(HyperionWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(HyperionWeb.ChangesetView)
    |> render("error.json", changeset: nil)
  end
end
