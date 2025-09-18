defmodule Hyperion.Repo.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hyperion.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "campaigns" do
    field :name, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:planned, :running, :completed, :archived]
    field :start_ts, :utc_datetime
    field :end_ts, :utc_datetime
    field :schedule, :string
    field :winner_experiment_id, :integer

    has_many :experiments, Repo.Experiment, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name, :description, :status, :start_ts, :end_ts, :schedule, :winner_experiment_id])
    |> validate_required([:name, :status, :start_ts, :end_ts])
  end
end
