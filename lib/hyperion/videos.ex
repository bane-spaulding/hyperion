import Ecto.Query, warn: false
alias Hyperion.Repo

defmodule Hyperion.Videos do
  defmodule Categories do
    alias Repo.Category

    def list_categories do
      Repo.all(Category)
    end
  end

  defmodule Titles do
    @moduledoc """
    The Titles context.
    """
    alias Repo.Title
    @doc """
    Returns the list of titles.

    ## Examples

        iex> list_titles()
        [%Title{}, ...]

    """
    def list_titles do
      Repo.all(Title)
    end

    @doc """
    Gets a single title.

    Raises `Ecto.NoResultsError` if the Title does not exist.

    ## Examples

        iex> get_title!(123)
        %Title{}

        iex> get_title!(456)
        ** (Ecto.NoResultsError)

    """
    def get_title!(id), do: Repo.get!(Title, id)

    def get_by(attrs) do
      list_titles()
      |> Enum.find(fn title ->
        Map.keys(attrs)
        |> Enum.all?(fn key ->
          title
          |> Map.get(key) === attrs[key]
        end)
      end)
    end

    @doc """
    Creates a title.

    ## Examples

        iex> create_title(%{field: value})
        {:ok, %Title{}}

        iex> create_title(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_title(attrs) do
      %Title{}
      |> Title.changeset(attrs)
      |> Repo.insert()
    end

    @doc """
    Updates a title.

    ## Examples

        iex> update_title(title, %{field: new_value})
        {:ok, %Title{}}

        iex> update_title(title, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def update_title(%Title{} = title, attrs) do
      title
      |> Title.changeset(attrs)
      |> Repo.update()
    end

    @doc """
    Deletes a title.

    ## Examples

        iex> delete_title(title)
        {:ok, %Title{}}

        iex> delete_title(title)
        {:error, %Ecto.Changeset{}}

    """
    def delete_title(%Title{} = title) do
      Repo.delete(title)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking title changes.

    ## Examples

        iex> change_title(title)
        %Ecto.Changeset{data: %Title{}}

    """
    def change_title(%Title{} = title, attrs \\ %{}) do
      Title.changeset(title, attrs)
    end
  end


  defmodule Thumbnails do
    alias Repo.Thumbnail

    def list_thumbnails do
      Repo.all(Thumbnail)
    end

    def get_thumbnail!(id), do: Repo.get!(Thumbnail, id)

    def insert_thumbnail(%Plug.Upload{} = upload, video_id, channel_id) do
      {:ok, binary_data} = File.read(upload.path)

      attrs = %{
        data: binary_data,
        content_type: upload.content_type,
        video_id: video_id,
        channel_id: channel_id
      }

      %Thumbnail{}
      |> Thumbnail.changeset(attrs)
      |> Repo.insert()
    end
  end
end
