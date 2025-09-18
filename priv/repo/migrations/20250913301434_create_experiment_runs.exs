defmodule Hyperion.Repo.Migrations.CreateExperimentRuns do
  use Ecto.Migration

  def change do
    create table(:experiment_runs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :run_number, :integer, null: false
      add :status, :string, null: false
      add :start_ts, :utc_datetime, null: false
      add :end_ts, :utc_datetime, null: false
      add :schedule_window, :interval
      add :allocation_strategy, :map
      add :view_count, :integer, default: 0

      add :experiment_id, references(:experiments, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:experiment_runs, [:experiment_id])
    create index(:experiment_runs, [:status])
    create unique_index(:experiment_runs, [:experiment_id, :run_number], name: :experiment_runs_experiment_run_number_index)
  end
end
