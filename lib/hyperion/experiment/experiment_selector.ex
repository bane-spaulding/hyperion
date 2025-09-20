 defmodule Hyperion.Experiments.ExperimentSelector do
  @moduledoc """
  A module for selecting experiments based on different distribution types.
  """

  @doc """
  Selects a single experiment from a list using a uniform random distribution.

  This function ensures that each experiment in the list has an equal probability of being chosen.

  ## Examples
      iex> experiments = [%{id: 1}, %{id: 2}, %{id: 3}]
      iex> Hyperion.ExperimentSelector.uniform_picker(experiments)
      # a random experiment from the list
  """
  def uniform_picker(experiments) when is_list(experiments) and length(experiments) > 0 do
    Enum.random(experiments)
  end

  def uniform_picker(_experiments), do: nil
end

