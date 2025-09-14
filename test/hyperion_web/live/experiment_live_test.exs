defmodule HyperionWeb.ExperimentLiveTest do
  use HyperionWeb.ConnCase

  import Phoenix.LiveViewTest
  import Hyperion.ExperimentsFixtures

  @create_attrs %{title: "some title", channel_id: "some channel_id", video_id: "some video_id", views: 42, thumbnail_id: 42}
  @update_attrs %{title: "some updated title", channel_id: "some updated channel_id", video_id: "some updated video_id", views: 43, thumbnail_id: 43}
  @invalid_attrs %{title: nil, channel_id: nil, video_id: nil, views: nil, thumbnail_id: nil}
  defp create_experiment(_) do
    experiment = experiment_fixture()

    %{experiment: experiment}
  end

  describe "Index" do
    setup [:create_experiment]

    test "lists all experiments", %{conn: conn, experiment: experiment} do
      {:ok, _index_live, html} = live(conn, ~p"/experiments")

      assert html =~ "Listing Experiments"
      assert html =~ experiment.channel_id
    end

    test "saves new experiment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/experiments")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Experiment")
               |> render_click()
               |> follow_redirect(conn, ~p"/experiments/new")

      assert render(form_live) =~ "New Experiment"

      assert form_live
             |> form("#experiment-form", experiment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#experiment-form", experiment: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/experiments")

      html = render(index_live)
      assert html =~ "Experiment created successfully"
      assert html =~ "some channel_id"
    end

    test "updates experiment in listing", %{conn: conn, experiment: experiment} do
      {:ok, index_live, _html} = live(conn, ~p"/experiments")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#experiments-#{experiment.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/experiments/#{experiment}/edit")

      assert render(form_live) =~ "Edit Experiment"

      assert form_live
             |> form("#experiment-form", experiment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#experiment-form", experiment: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/experiments")

      html = render(index_live)
      assert html =~ "Experiment updated successfully"
      assert html =~ "some updated channel_id"
    end

    test "deletes experiment in listing", %{conn: conn, experiment: experiment} do
      {:ok, index_live, _html} = live(conn, ~p"/experiments")

      assert index_live |> element("#experiments-#{experiment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#experiments-#{experiment.id}")
    end
  end

  describe "Show" do
    setup [:create_experiment]

    test "displays experiment", %{conn: conn, experiment: experiment} do
      {:ok, _show_live, html} = live(conn, ~p"/experiments/#{experiment}")

      assert html =~ "Show Experiment"
      assert html =~ experiment.channel_id
    end

    test "updates experiment and returns to show", %{conn: conn, experiment: experiment} do
      {:ok, show_live, _html} = live(conn, ~p"/experiments/#{experiment}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/experiments/#{experiment}/edit?return_to=show")

      assert render(form_live) =~ "Edit Experiment"

      assert form_live
             |> form("#experiment-form", experiment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#experiment-form", experiment: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/experiments/#{experiment}")

      html = render(show_live)
      assert html =~ "Experiment updated successfully"
      assert html =~ "some updated channel_id"
    end
  end
end
