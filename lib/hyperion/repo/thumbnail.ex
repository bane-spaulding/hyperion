defmodule Hyperion.Repo.Thumbnail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "thumbnails" do
    field :data, :binary
    field :content_type, :string
    field :channel_id, :string
    field :video_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thumbnail, attrs) do
    thumbnail
    |> cast(attrs, [:data, :content_type, :channel_id, :video_id])
    |> validate_required([:data, :content_type, :channel_id, :video_id])
  end
end
