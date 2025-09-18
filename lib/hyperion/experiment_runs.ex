defmodule Hyperion.ExperimentRuns do
  @moduledoc """
  The ExperimentRuns context.
  """

  import Ecto.Query, warn: false
  alias Hyperion.Repo
  alias Hyperion.Repo.ExperimentRun

  @doc """
  Returns the list of experiment runs.

  ## Examples

      iex> list_experiment_runs()
      [%ExperimentRun{}, ...]

  """
  def list_experiment_runs do
    Repo.all(ExperimentRun)
  end

  @doc """
  Gets a single experiment run.

  Raises `Ecto.NoResultsError` if the ExperimentRun does not exist.

  ## Examples

      iex> get_experiment_run!("74872c05-19e3-4611-a88f-141a04d53372")
      %ExperimentRun{}

      iex> get_experiment_run!("4567-dead-beef-8901")
      ** (Ecto.NoResultsError)

  """
  def get_experiment_run!(id), do: Repo.get!(ExperimentRun, id)

  @doc """
  Creates an experiment run.

  ## Examples

      iex> create_experiment_run(%{field: value})
      {:ok, %ExperimentRun{}}

      iex> create_experiment_run(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_experiment_run(attrs \\ %{}) do
    %ExperimentRun{}
    |> ExperimentRun.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an experiment run.

  ## Examples

      iex> update_experiment_run(experiment_run, %{field: new_value})
      {:ok, %ExperimentRun{}}

      iex> update_experiment_run(experiment_run, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_experiment_run(%ExperimentRun{} = experiment_run, attrs) do
    experiment_run
    |> ExperimentRun.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an experiment run.

  ## Examples

      iex> delete_experiment_run(experiment_run)
      {:ok, %ExperimentRun{}}

      iex> delete_experiment_run(experiment_run)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experiment_run(%ExperimentRun{} = experiment_run) do
    Repo.delete(experiment_run)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking experiment run changes.

  ## Examples

      iex> change_experiment_run(experiment_run)
      %Ecto.Changeset{data: %ExperimentRun{}}

  """
  def change_experiment_run(%ExperimentRun{} = experiment_run, attrs \\ %{}) do
    ExperimentRun.changeset(experiment_run, attrs)
  end
end
