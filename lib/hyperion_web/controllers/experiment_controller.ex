defmodule HyperionWeb.ExperimentController do
  use HyperionWeb, :controller

  alias Hyperion.Experiments
  alias Hyperion.Repo.Experiment

  def index(conn, _params) do
    experiments = Experiments.list_experiments()
    render(conn, :index, experiments: experiments)
  end

  def new(conn, _params) do
    changeset = Experiments.change_experiment(%Experiment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"experiment" => experiment_params}) do
    case Experiments.create_experiment(experiment_params) do
      {:ok, experiment} ->
        conn
        |> put_flash(:info, "Experiment created successfully.")
        |> redirect(to: ~p"/experiments/#{experiment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    experiment = Experiments.get_experiment!(id)
    render(conn, :show, experiment: experiment)
  end

  def edit(conn, %{"id" => id}) do
    experiment = Experiments.get_experiment!(id)
    changeset = Experiments.change_experiment(experiment)
    render(conn, :edit, experiment: experiment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "experiment" => experiment_params}) do
    experiment = Experiments.get_experiment!(id)

    case Experiments.update_experiment(experiment, experiment_params) do
      {:ok, experiment} ->
        conn
        |> put_flash(:info, "Experiment updated successfully.")
        |> redirect(to: ~p"/experiments/#{experiment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, experiment: experiment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    experiment = Experiments.get_experiment!(id)
    {:ok, _experiment} = Experiments.delete_experiment(experiment)

    conn
    |> put_flash(:info, "Experiment deleted successfully.")
    |> redirect(to: ~p"/experiments")
  end
end
