defmodule HyperionWeb.ExperimentControllerTest do
  use HyperionWeb.ConnCase

  import Hyperion.ExperimentsFixtures

  @create_attrs %{title: "some title", thumbnail: "some thumbnail", views: 42, clicks: 42, user_id: 42}
  @update_attrs %{title: "some updated title", thumbnail: "some updated thumbnail", views: 43, clicks: 43, user_id: 43}
  @invalid_attrs %{title: nil, thumbnail: nil, views: nil, clicks: nil, user_id: nil}

  describe "index" do
    test "lists all experiments", %{conn: conn} do
      conn = get(conn, ~p"/experiments")
      assert html_response(conn, 200) =~ "Listing Experiments"
    end
  end

  describe "new experiment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/experiments/new")
      assert html_response(conn, 200) =~ "New Experiment"
    end
  end

  describe "create experiment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/experiments", experiment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/experiments/#{id}"

      conn = get(conn, ~p"/experiments/#{id}")
      assert html_response(conn, 200) =~ "Experiment #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/experiments", experiment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Experiment"
    end
  end

  describe "edit experiment" do
    setup [:create_experiment]

    test "renders form for editing chosen experiment", %{conn: conn, experiment: experiment} do
      conn = get(conn, ~p"/experiments/#{experiment}/edit")
      assert html_response(conn, 200) =~ "Edit Experiment"
    end
  end

  describe "update experiment" do
    setup [:create_experiment]

    test "redirects when data is valid", %{conn: conn, experiment: experiment} do
      conn = put(conn, ~p"/experiments/#{experiment}", experiment: @update_attrs)
      assert redirected_to(conn) == ~p"/experiments/#{experiment}"

      conn = get(conn, ~p"/experiments/#{experiment}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, experiment: experiment} do
      conn = put(conn, ~p"/experiments/#{experiment}", experiment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Experiment"
    end
  end

  describe "delete experiment" do
    setup [:create_experiment]

    test "deletes chosen experiment", %{conn: conn, experiment: experiment} do
      conn = delete(conn, ~p"/experiments/#{experiment}")
      assert redirected_to(conn) == ~p"/experiments"

      assert_error_sent 404, fn ->
        get(conn, ~p"/experiments/#{experiment}")
      end
    end
  end

  defp create_experiment(_) do
    experiment = experiment_fixture()

    %{experiment: experiment}
  end
end
