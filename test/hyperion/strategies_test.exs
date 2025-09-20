defmodule Hyperion.StrategiesTest do
  use Hyperion.DataCase

  alias Hyperion.Strategies

  describe "strategies" do
    alias Hyperion.Strategies.Repo.Hyperion.Strategy

    import Hyperion.StrategiesFixtures

    @invalid_attrs %{name: nil, status: nil, description: nil, start_ts: nil, end_ts: nil, schedule: nil, winner_experiment_id: nil}

    test "list_strategies/0 returns all strategies" do
      strategy = strategy_fixture()
      assert Strategies.list_strategies() == [strategy]
    end

    test "get_strategy!/1 returns the strategy with given id" do
      strategy = strategy_fixture()
      assert Strategies.get_strategy!(strategy.id) == strategy
    end

    test "create_strategy/1 with valid data creates a strategy" do
      valid_attrs = %{name: "some name", status: "some status", description: "some description", start_ts: ~U[2025-09-19 21:11:00Z], end_ts: ~U[2025-09-19 21:11:00Z], schedule: "some schedule", winner_experiment_id: 42}

      assert {:ok, %Strategy{} = strategy} = Strategies.create_strategy(valid_attrs)
      assert strategy.name == "some name"
      assert strategy.status == "some status"
      assert strategy.description == "some description"
      assert strategy.start_ts == ~U[2025-09-19 21:11:00Z]
      assert strategy.end_ts == ~U[2025-09-19 21:11:00Z]
      assert strategy.schedule == "some schedule"
      assert strategy.winner_experiment_id == 42
    end

    test "create_strategy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Strategies.create_strategy(@invalid_attrs)
    end

    test "update_strategy/2 with valid data updates the strategy" do
      strategy = strategy_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", description: "some updated description", start_ts: ~U[2025-09-20 21:11:00Z], end_ts: ~U[2025-09-20 21:11:00Z], schedule: "some updated schedule", winner_experiment_id: 43}

      assert {:ok, %Strategy{} = strategy} = Strategies.update_strategy(strategy, update_attrs)
      assert strategy.name == "some updated name"
      assert strategy.status == "some updated status"
      assert strategy.description == "some updated description"
      assert strategy.start_ts == ~U[2025-09-20 21:11:00Z]
      assert strategy.end_ts == ~U[2025-09-20 21:11:00Z]
      assert strategy.schedule == "some updated schedule"
      assert strategy.winner_experiment_id == 43
    end

    test "update_strategy/2 with invalid data returns error changeset" do
      strategy = strategy_fixture()
      assert {:error, %Ecto.Changeset{}} = Strategies.update_strategy(strategy, @invalid_attrs)
      assert strategy == Strategies.get_strategy!(strategy.id)
    end

    test "delete_strategy/1 deletes the strategy" do
      strategy = strategy_fixture()
      assert {:ok, %Strategy{}} = Strategies.delete_strategy(strategy)
      assert_raise Ecto.NoResultsError, fn -> Strategies.get_strategy!(strategy.id) end
    end

    test "change_strategy/1 returns a strategy changeset" do
      strategy = strategy_fixture()
      assert %Ecto.Changeset{} = Strategies.change_strategy(strategy)
    end
  end
end
