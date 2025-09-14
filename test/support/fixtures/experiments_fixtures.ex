defmodule Hyperion.ExperimentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hyperion.Experiments` context.
  """

  @doc """
  Generate a experiment.
  """
  def experiment_fixture(attrs \\ %{}) do
    {:ok, experiment} =
      attrs
      |> Enum.into(%{
        clicks: 42,
        thumbnail: "some thumbnail",
        title: "some title",
        user_id: 42,
        views: 42
      })
      |> Hyperion.Experiments.create_experiment()

    experiment
  end

  @doc """
  Generate a experiment.
  """
  def experiment_fixture(attrs \\ %{}) do
    {:ok, experiment} =
      attrs
      |> Enum.into(%{
        channel_id: "some channel_id",
        thumbnail_id: 42,
        title: "some title",
        video_id: "some video_id",
        views: 42
      })
      |> Hyperion.Experiments.create_experiment()

    experiment
  end
end
