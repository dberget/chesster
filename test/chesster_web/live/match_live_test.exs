defmodule ChessterWeb.MatchLiveTest do
  use ChessterWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Chesster.Chess

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:match) do
    {:ok, match} = Chess.create_match(@create_attrs)
    match
  end

  defp create_match(_) do
    match = fixture(:match)
    %{match: match}
  end

  describe "Index" do
    setup [:create_match]

    test "lists all matches", %{conn: conn, match: match} do
      {:ok, _index_live, html} = live(conn, Routes.match_index_path(conn, :index))

      assert html =~ "Listing Matches"
    end

    test "saves new match", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.match_index_path(conn, :index))

      assert index_live |> element("a", "New Match") |> render_click() =~
               "New Match"

      assert_patch(index_live, Routes.match_index_path(conn, :new))

      assert index_live
             |> form("#match-form", match: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#match-form", match: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.match_index_path(conn, :index))

      assert html =~ "Match created successfully"
    end

    test "updates match in listing", %{conn: conn, match: match} do
      {:ok, index_live, _html} = live(conn, Routes.match_index_path(conn, :index))

      assert index_live |> element("#match-#{match.id} a", "Edit") |> render_click() =~
               "Edit Match"

      assert_patch(index_live, Routes.match_index_path(conn, :edit, match))

      assert index_live
             |> form("#match-form", match: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#match-form", match: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.match_index_path(conn, :index))

      assert html =~ "Match updated successfully"
    end

    test "deletes match in listing", %{conn: conn, match: match} do
      {:ok, index_live, _html} = live(conn, Routes.match_index_path(conn, :index))

      assert index_live |> element("#match-#{match.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#match-#{match.id}")
    end
  end

  describe "Show" do
    setup [:create_match]

    test "displays match", %{conn: conn, match: match} do
      {:ok, _show_live, html} = live(conn, Routes.match_show_path(conn, :show, match))

      assert html =~ "Show Match"
    end

    test "updates match within modal", %{conn: conn, match: match} do
      {:ok, show_live, _html} = live(conn, Routes.match_show_path(conn, :show, match))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Match"

      assert_patch(show_live, Routes.match_show_path(conn, :edit, match))

      assert show_live
             |> form("#match-form", match: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#match-form", match: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.match_show_path(conn, :show, match))

      assert html =~ "Match updated successfully"
    end
  end
end
