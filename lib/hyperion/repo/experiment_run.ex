defmodule Hyperion.Repo.ExperimentRun do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hyperion.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "experiment_runs" do
    field :run_number, :integer
    field :status, Ecto.Enum, values: [:scheduled, :running, :completed, :aborted]
    field :start_ts, :utc_datetime
    field :end_ts, :utc_datetime
    field :schedule_window, :duration
    field :allocation_strategy, :map
    field :view_count, :integer

    belongs_to :experiment, Repo.Experiment, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(experiment_run, attrs) do
    experiment_run
    |> cast(attrs, [
      :experiment_id,
      :run_number,
      :status,
      :start_ts,
      :end_ts,
      :schedule_window,
      :allocation_strategy,
      :view_count
    ])
    |> validate_required([:experiment_id, :run_number, :status, :start_ts, :end_ts])
    |> unique_constraint(:run_number, name: :experiment_runs_experiment_run_number_index)

  end
end
