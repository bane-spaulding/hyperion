# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hyperion.Repo.insert!(%Hyperion.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Hyperion.Repo
alias Hyperion.Repo.Category

require Logger

data_to_insert = [
  %{category_id: 1, title: "Film & Animation"},
  %{category_id: 2, title: "Autos & Vehicles"},
  %{category_id: 10, title: "Music"},
  %{category_id: 15, title: "Pets & Animals"},
  %{category_id: 17, title: "Sports"},
  %{category_id: 18, title: "Short Movies"},
  %{category_id: 19, title: "Travel & Events"},
  %{category_id: 20, title: "Gaming"},
  %{category_id: 21, title: "Videoblogging"},
  %{category_id: 22, title: "People & Blogs"},
  %{category_id: 23, title: "Comedy"},
  %{category_id: 24, title: "Entertainment"},
  %{category_id: 25, title: "News & Politics"},
  %{category_id: 26, title: "Howto & Style"},
  %{category_id: 27, title: "Education"},
  %{category_id: 28, title: "Science & Technology"},
  %{category_id: 29, title: "Nonprofits & Activism"},
  %{category_id: 30, title: "Movies"},
  %{category_id: 31, title: "Anime/Animation"},
  %{category_id: 32, title: "Action/Adventure"},
  %{category_id: 33, title: "Classics"},
  %{category_id: 34, title: "Comedy"},
  %{category_id: 35, title: "Documentary"},
  %{category_id: 36, title: "Drama"},
  %{category_id: 37, title: "Family"},
  %{category_id: 38, title: "Foreign"},
  %{category_id: 39, title: "Horror"},
  %{category_id: 40, title: "Sci-Fi/Fantasy"},
  %{category_id: 41, title: "Thriller"},
  %{category_id: 42, title: "Shorts"},
  %{category_id: 43, title: "Shows"},
  %{category_id: 44, title: "Trailers"}
]

case Repo.insert_all(Category, data_to_insert) do
   {count, nil} ->
     Logger.info("Successfully inserted #{count} records into the categories table.")
   {_count, %Ecto.Changeset{} = changeset} ->
     Logger.error("Failed to insert records: #{inspect(changeset.errors)}")
end
