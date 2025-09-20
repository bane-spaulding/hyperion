defmodule Hyperion.StrategiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hyperion.Strategies` context.
  """

  @doc """
  Generate a strategy.
  """
  def strategy_fixture(attrs \\ %{}) do
    {:ok, strategy} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_ts: ~U[2025-09-19 21:11:00Z],
        name: "some name",
        schedule: "some schedule",
        start_ts: ~U[2025-09-19 21:11:00Z],
        status: "some status",
        winner_experiment_id: 42
      })
      |> Hyperion.Strategies.create_strategy()

    strategy
  end
end
