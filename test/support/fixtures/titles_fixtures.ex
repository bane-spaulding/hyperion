defmodule Hyperion.TitlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hyperion.Titles` context.
  """

  @doc """
  Generate a title.
  """
  def title_fixture(attrs \\ %{}) do
    {:ok, title} =
      attrs
      |> Enum.into(%{
        title: "some title",
        video_id: "some video_id"
      })
      |> Hyperion.Titles.create_title()

    title
  end
end
