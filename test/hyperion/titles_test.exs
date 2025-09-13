defmodule Hyperion.TitlesTest do
  use Hyperion.DataCase

  alias Hyperion.Titles

  describe "titles" do
    alias Hyperion.Titles.Repo.Title

    import Hyperion.TitlesFixtures

    @invalid_attrs %{title: nil, video_id: nil}

    test "list_titles/0 returns all titles" do
      title = title_fixture()
      assert Titles.list_titles() == [title]
    end

    test "get_title!/1 returns the title with given id" do
      title = title_fixture()
      assert Titles.get_title!(title.id) == title
    end

    test "create_title/1 with valid data creates a title" do
      valid_attrs = %{title: "some title", video_id: "some video_id"}

      assert {:ok, %Title{} = title} = Titles.create_title(valid_attrs)
      assert title.title == "some title"
      assert title.video_id == "some video_id"
    end

    test "create_title/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Titles.create_title(@invalid_attrs)
    end

    test "update_title/2 with valid data updates the title" do
      title = title_fixture()
      update_attrs = %{title: "some updated title", video_id: "some updated video_id"}

      assert {:ok, %Title{} = title} = Titles.update_title(title, update_attrs)
      assert title.title == "some updated title"
      assert title.video_id == "some updated video_id"
    end

    test "update_title/2 with invalid data returns error changeset" do
      title = title_fixture()
      assert {:error, %Ecto.Changeset{}} = Titles.update_title(title, @invalid_attrs)
      assert title == Titles.get_title!(title.id)
    end

    test "delete_title/1 deletes the title" do
      title = title_fixture()
      assert {:ok, %Title{}} = Titles.delete_title(title)
      assert_raise Ecto.NoResultsError, fn -> Titles.get_title!(title.id) end
    end

    test "change_title/1 returns a title changeset" do
      title = title_fixture()
      assert %Ecto.Changeset{} = Titles.change_title(title)
    end
  end
end
