defmodule HyperionWeb.StrategyLiveTest do
  use HyperionWeb.ConnCase

  import Phoenix.LiveViewTest
  import Hyperion.StrategiesFixtures

  @create_attrs %{name: "some name", status: "some status", description: "some description", start_ts: "2025-09-19T21:11:00Z", end_ts: "2025-09-19T21:11:00Z", schedule: "some schedule", winner_experiment_id: 42}
  @update_attrs %{name: "some updated name", status: "some updated status", description: "some updated description", start_ts: "2025-09-20T21:11:00Z", end_ts: "2025-09-20T21:11:00Z", schedule: "some updated schedule", winner_experiment_id: 43}
  @invalid_attrs %{name: nil, status: nil, description: nil, start_ts: nil, end_ts: nil, schedule: nil, winner_experiment_id: nil}
  defp create_strategy(_) do
    strategy = strategy_fixture()

    %{strategy: strategy}
  end

  describe "Index" do
    setup [:create_strategy]

    test "lists all strategies", %{conn: conn, strategy: strategy} do
      {:ok, _index_live, html} = live(conn, ~p"/strategies")

      assert html =~ "Listing Strategies"
      assert html =~ strategy.name
    end

    test "saves new strategy", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/strategies")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Strategy")
               |> render_click()
               |> follow_redirect(conn, ~p"/strategies/new")

      assert render(form_live) =~ "New Strategy"

      assert form_live
             |> form("#strategy-form", strategy: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#strategy-form", strategy: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/strategies")

      html = render(index_live)
      assert html =~ "Strategy created successfully"
      assert html =~ "some name"
    end

    test "updates strategy in listing", %{conn: conn, strategy: strategy} do
      {:ok, index_live, _html} = live(conn, ~p"/strategies")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#strategies-#{strategy.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/strategies/#{strategy}/edit")

      assert render(form_live) =~ "Edit Strategy"

      assert form_live
             |> form("#strategy-form", strategy: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#strategy-form", strategy: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/strategies")

      html = render(index_live)
      assert html =~ "Strategy updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes strategy in listing", %{conn: conn, strategy: strategy} do
      {:ok, index_live, _html} = live(conn, ~p"/strategies")

      assert index_live |> element("#strategies-#{strategy.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#strategies-#{strategy.id}")
    end
  end

  describe "Show" do
    setup [:create_strategy]

    test "displays strategy", %{conn: conn, strategy: strategy} do
      {:ok, _show_live, html} = live(conn, ~p"/strategies/#{strategy}")

      assert html =~ "Show Strategy"
      assert html =~ strategy.name
    end

    test "updates strategy and returns to show", %{conn: conn, strategy: strategy} do
      {:ok, show_live, _html} = live(conn, ~p"/strategies/#{strategy}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/strategies/#{strategy}/edit?return_to=show")

      assert render(form_live) =~ "Edit Strategy"

      assert form_live
             |> form("#strategy-form", strategy: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#strategy-form", strategy: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/strategies/#{strategy}")

      html = render(show_live)
      assert html =~ "Strategy updated successfully"
      assert html =~ "some updated name"
    end
  end
end
