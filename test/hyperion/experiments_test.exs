defmodule Hyperion.ExperimentsTest do
  use Hyperion.DataCase

  alias Hyperion.Experiments

  describe "experiments" do
    alias Hyperion.Experiments.Experiment

    import Hyperion.ExperimentsFixtures

    @invalid_attrs %{title: nil, thumbnail: nil, views: nil, clicks: nil, user_id: nil}

    test "list_experiments/0 returns all experiments" do
      experiment = experiment_fixture()
      assert Experiments.list_experiments() == [experiment]
    end

    test "get_experiment!/1 returns the experiment with given id" do
      experiment = experiment_fixture()
      assert Experiments.get_experiment!(experiment.id) == experiment
    end

    test "create_experiment/1 with valid data creates a experiment" do
      valid_attrs = %{
        title: "some title",
        thumbnail: "some thumbnail",
        views: 42,
        clicks: 42,
        user_id: 42
      }

      assert {:ok, %Experiment{} = experiment} = Experiments.create_experiment(valid_attrs)
      assert experiment.title == "some title"
      assert experiment.thumbnail == "some thumbnail"
      assert experiment.views == 42
      assert experiment.clicks == 42
      assert experiment.user_id == 42
    end

    test "create_experiment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Experiments.create_experiment(@invalid_attrs)
    end

    test "update_experiment/2 with valid data updates the experiment" do
      experiment = experiment_fixture()

      update_attrs = %{
        title: "some updated title",
        thumbnail: "some updated thumbnail",
        views: 43,
        clicks: 43,
        user_id: 43
      }

      assert {:ok, %Experiment{} = experiment} =
               Experiments.update_experiment(experiment, update_attrs)

      assert experiment.title == "some updated title"
      assert experiment.thumbnail == "some updated thumbnail"
      assert experiment.views == 43
      assert experiment.clicks == 43
      assert experiment.user_id == 43
    end

    test "update_experiment/2 with invalid data returns error changeset" do
      experiment = experiment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Experiments.update_experiment(experiment, @invalid_attrs)

      assert experiment == Experiments.get_experiment!(experiment.id)
    end

    test "delete_experiment/1 deletes the experiment" do
      experiment = experiment_fixture()
      assert {:ok, %Experiment{}} = Experiments.delete_experiment(experiment)
      assert_raise Ecto.NoResultsError, fn -> Experiments.get_experiment!(experiment.id) end
    end

    test "change_experiment/1 returns a experiment changeset" do
      experiment = experiment_fixture()
      assert %Ecto.Changeset{} = Experiments.change_experiment(experiment)
    end
  end
end
