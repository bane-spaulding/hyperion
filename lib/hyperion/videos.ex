alias Hyperion.Repo
import Ecto.Query, warn: false

defmodule Hyperion.Videos do
  alias Repo.Video

  @doc """
  Retrieves the video record with views closest to the given timestamp.
  """
  def get_views_closest_to_timestamp(video_id, timestamp) do
    from(v in Video,
      where: v.video_id == ^video_id,
      order_by: fragment("ABS(EXTRACT(EPOCH FROM (? - ?)))", v.inserted_at, ^timestamp),
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Retrieves latest video counts for a given video
  """
  def get_last_view_counts(video_ids) do
    video_ids
    |> Enum.map(fn video_id ->
      case Repo.one(from v in Video,
        where: v.video_id == ^video_id,
        order_by: [desc: v.inserted_at],
        limit: 1,
        select: v.view_count
      ) do
        nil -> {video_id, 0}
        count -> {video_id, count}
      end
    end)
    |> Map.new()
  end

  defmodule Categories do
    alias Repo.Category

    def list_categories do
      Repo.all(Category)
    end
  end

  defmodule Thumbnails do
    alias Repo.Thumbnail

    def list_thumbnails do
      Repo.all(Thumbnail)
    end

    def get_thumbnail!(id), do: Repo.get!(Thumbnail, id)

    def get_by(attrs) do
      list_thumbnails()
      |> Enum.find(fn thumbnail ->
        Map.keys(attrs)
        |> Enum.all?(fn key ->
          thumbnail
          |> Map.get(key) === attrs[key]
        end)
      end)
    end


    def insert_thumbnail(%Plug.Upload{} = upload, video_id, channel_id, experiment_id) do
      {:ok, binary_data} = File.read(upload.path)

      attrs = %{
        file_id: upload.filename,
        video_id: video_id,
        channel_id: channel_id,
        data: binary_data,
        content_type: upload.content_type,
        experiment_id: experiment_id
      }

      %Thumbnail{}
      |> Thumbnail.changeset(attrs)
      |> Repo.insert()
    end
  end
end
