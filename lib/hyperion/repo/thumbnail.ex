defmodule Hyperion.Repo.Thumbnail do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "thumbnails" do
    field :file_id, :string
    field :data, :binary
    field :content_type, :string

    belongs_to :experiment, Hyperion.Repo.Experiment, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thumbnail, attrs) do
    thumbnail
    |> cast(attrs, [:file_id, :data, :content_type])
    |> validate_required([:file_id, :data, :content_type])
  end
end
