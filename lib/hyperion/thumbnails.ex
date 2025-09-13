defmodule Hyperion.Thumbnails do
  import Ecto.Query, warn: false
  alias Hyperion.Repo
  alias Hyperion.Repo.Thumbnail

  def list_thumbnails do
    Repo.all(Thumbnail)
  end

  def get_thumbnail!(id), do: Repo.get!(Thumbnail, id)

  def insert_thumbnail(%Plug.Upload{} = upload, video_id, channel_id) do
    {:ok, binary_data} = File.read(upload.path)

    attrs = %{
      data: binary_data,
      content_type: upload.content_type,
      video_id: video_id,
      channel_id: channel_id
    }

    %Thumbnail{}
    |> Thumbnail.changeset(attrs)
    |> Repo.insert()
  end
end
