defmodule Hyperion.Repo.Thumbnail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "thumbnails" do
    field :file_id, :string
    field :video_id, :string
    field :channel_id, :string
    field :data, :binary
    field :content_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thumbnail, attrs) do
    thumbnail
    |> cast(attrs, [:file_id, :video_id, :channel_id, :data, :content_type])
    |> validate_required([:video_id, :channel_id, :data, :content_type])
  end
end
