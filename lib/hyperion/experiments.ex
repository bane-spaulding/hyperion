defmodule Hyperion.Experiments do
  @moduledoc """
  The Experiments context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Hyperion.Repo
  alias Hyperion.Repo.{Experiment, ExperimentRun, Thumbnail}

  @doc """
  Returns the list of experiments.

  ## Examples

      iex> list_experiments()
      [%Experiment{}, ...]

  """
  def list_experiments do
    Experiment
    |> Repo.all()
    |> Repo.preload(:thumbnail)
  end

  @doc """
  Returns a list of all experiments that are currently active.
  """
  def list_active_experiments do
    Experiment
    |> where(is_active: true)
    |> Repo.all()
  end

  @doc """
  Gets a single experiment.

  Raises `Ecto.NoResultsError` if the Experiment does not exist.

  ## Examples

      iex> get_experiment!(123)
      %Experiment{}

      iex> get_experiment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_experiment!(id) do
    Experiment
    |> Repo.get!(id)
    |> Repo.preload(:thumbnail)
  end

  def get_experiment(id), do: Repo.get!(Experiment, id)

  @doc """
  Returns an active experiment for a given video ID.
  """
  def get_active_experiment_by_video_id(video_id) do
    from(e in Experiment,
      where: e.is_active == true and e.video_id == ^video_id
    )
    |> Repo.one()
  end

  @doc """
  Returns the single active experiment and preloads its associated run.
  """
  def get_active_experiment_with_run do
    Experiment
    |> where(is_active: true)
    |> Repo.preload(:experiment_run)
    |> Repo.one()
  end

  @doc """
  Creates a experiment.


  #i Examples

      iex> create_experiment(%{field: value})
      {:ok, %Experiment{}}

      iex> create_experiment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_experiment(attrs) do
    %Experiment{}
    |> Experiment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Creates an experiment and its thumbnail in one atomic transaction.
    Returns {:ok, %{experiment: experiment, thumbnail: thumbnail}}.
  """
  def create_experiment_with_thumbnail(exp_attrs, thumb_attrs) do
    Multi.new()
      |> Multi.insert(:experiment, Experiment.changeset(%Experiment{}, exp_attrs))
      |> Multi.insert(:thumbnail, fn %{experiment: exp} -> exp
        |> Ecto.build_assoc(:thumbnail, thumb_attrs)
        |> Thumbnail.changeset(%{})
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates an experiment and its thumbnail in one atomic transaction.
  Returns {:ok, %{experiment: experiment, thumbnail: thumbnail}}.
  """
    def update_experiment_with_thumbnail(%Experiment{thumbnail: thumbnail} = experiment, exp_attrs, thumb_attrs) do
  Multi.new()
  |> Multi.update(:experiment, Experiment.changeset(experiment, exp_attrs))
  |> Multi.update(:thumbnail, Thumbnail.changeset(thumbnail, thumb_attrs))
  |> Repo.transaction()
end
  @doc """
  Updates a experiment.

  ## Examples

      iex> update_experiment(experiment, %{field: new_value})
      {:ok, %Experiment{}}

      iex> update_experiment(experiment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_experiment(%Experiment{} = experiment, attrs) do
     experiment
    |> Experiment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a experiment.

  ## Examples

      iex> delete_experiment(experiment)
      {:ok, %Experiment{}}

      iex> delete_experiment(experiment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experiment(%Experiment{} = experiment) do
    Repo.delete(experiment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking experiment changes.

  ## Examples

      iex> change_experiment(experiment)
      %Ecto.Changeset{data: %Experiment{}}

  """
  def change_experiment(%Experiment{} = experiment, attrs \\ %{}) do
    Experiment.changeset(experiment, attrs)
  end
end
