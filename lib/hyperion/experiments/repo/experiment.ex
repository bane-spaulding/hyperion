defmodule Hyperion.Experiments.Repo.Experiment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "experiments" do
    field :title, :string
    field :thumbnail, :string
    field :views, :integer
    field :clicks, :integer
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(experiment, attrs) do
    experiment
    |> cast(attrs, [:title, :thumbnail, :views, :clicks, :user_id])
    |> validate_required([:title, :thumbnail, :views, :clicks, :user_id])
  end
end
