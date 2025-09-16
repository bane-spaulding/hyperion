defmodule Hyperion.Repo.Experiment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hyperion.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "experiments" do
    field :title, :string
    field :video_id, :string
    field :channel_id, :string
    field :category_id, :integer

    has_one :thumbnail, Repo.Thumbnail, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(experiment, attrs) do
    shared = [
      :category_id,
      :channel_id,
      :title,
      :video_id
    ]

    experiment
    |> cast(attrs, shared)
    |> validate_required(shared)
  end
end
