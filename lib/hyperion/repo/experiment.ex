defmodule Hyperion.Repo.Experiment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "experiments" do
    field :channel_id, :string
    field :video_id, :string
    field :title, :string
    field :views, :integer
    field :thumbnail_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(experiment, attrs) do
    experiment
    |> cast(attrs, [:channel_id, :video_id, :title, :views, :thumbnail_id])
    |> validate_required([:channel_id, :video_id, :title])
  end
end
