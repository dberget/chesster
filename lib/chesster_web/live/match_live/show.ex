defmodule ChessterWeb.MatchLive.Show do
  use ChessterWeb, :live_view

  alias Chesster.Chess

  @pieces [
    %{square: "a1", id: "wR1", img: "wR.png"},
    %{square: "b1", id: "wN1", img: "wN.png"},
    %{square: "c1", id: "wB1", img: "wB.png"},
    %{square: "d1", id: "wQ", img: "wQ.png"},
    %{square: "e1", id: "wK", img: "wK.png"},
    %{square: "f1", id: "wN2", img: "wB.png"},
    %{square: "g1", id: "wB2", img: "wN.png"},
    %{square: "h1", id: "wR2", img: "wR.png"},
    %{square: "a2", id: "wP-1", img: "wP.png"},
    %{square: "b2", id: "wP-2", img: "wP.png"},
    %{square: "c2", id: "wP-3", img: "wP.png"},
    %{square: "d2", id: "wP-4", img: "wP.png"},
    %{square: "e2", id: "wP-5", img: "wP.png"},
    %{square: "f2", id: "wP-6", img: "wP.png"},
    %{square: "g2", id: "wP-7", img: "wP.png"},
    %{square: "h2", id: "wP-8", img: "wP.png"},
    %{square: "a8", id: "bR1", img: "bR.png"},
    %{square: "b8", id: "bN1", img: "bN.png"},
    %{square: "c8", id: "bB1", img: "bB.png"},
    %{square: "d8", id: "bQ", img: "bQ.png"},
    %{square: "e8", id: "bK", img: "bK.png"},
    %{square: "f8", id: "bB2", img: "bB.png"},
    %{square: "g8", id: "bN2", img: "bN.png"},
    %{square: "h8", id: "bR2", img: "bR.png"},
    %{square: "a7", id: "bP-1", img: "bp.png"},
    %{square: "b7", id: "bP-2", img: "bP.png"},
    %{square: "c7", id: "bP-3", img: "bP.png"},
    %{square: "d7", id: "bP-4", img: "bP.png"},
    %{square: "e7", id: "bP-5", img: "bP.png"},
    %{square: "f7", id: "bP-6", img: "bP.png"},
    %{square: "g7", id: "bP-7", img: "bP.png"},
    %{square: "h7", id: "bP-8", img: "bP.png"}
  ]

  @impl true
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(params, _session, socket) do
    Chesster.init(params["id"])

    {:ok, fen} = Chesster.fen(params["id"])

    socket =
      socket
      |> assign(:game_id, params["id"])
      |> assign(:pieces, @pieces)
      |> assign(:fen, fen)
      |> assign(:checkmate, false)
      |> assign(:game_type, :player_vs_player)

    {:ok, socket}
  end

  @impl true
  def handle_event("move", %{"move" => player_move}, socket) do
    case Chesster.play(socket.assigns.game_id, player_move, socket.assigns.game_type) do
      {:ok, :player, :continue} ->
        pieces =
          socket.assigns.pieces
          |> updatePosition(player_move)

        {:noreply, assign(socket, :pieces, pieces)}

      {:ok, :player, :checkmate} ->
        pieces =
          socket.assigns.pieces
          |> updatePosition(player_move)

        socket =
          socket
          |> assign(:pieces, pieces)
          |> assign(:checkmate, true)

        {:noreply, socket}

      {:ok, :continue, computer_move} ->
        pieces =
          socket.assigns.pieces
          |> updatePosition(player_move)
          |> updatePosition(computer_move)

        {:noreply, assign(socket, :pieces, pieces)}

      {:ok, :checkmate, computer_move} ->
        pieces =
          socket.assigns.pieces
          |> updatePosition(player_move)
          |> updatePosition(computer_move)

        socket =
          socket
          |> assign(:pieces, pieces)
          |> assign(:checkmate, true)

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  defp updatePosition(pieces, move) do
    {old_pos, new_pos} = String.split_at(move, 2)

    captured_piece = Enum.find_index(pieces, &(&1.square == new_pos))

    pieces =
      if !is_nil(captured_piece) do
        [piece] = Enum.filter(pieces, &(&1.square == new_pos))
        piece = %{piece | square: nil}

        List.replace_at(pieces, captured_piece, piece)
      else
        pieces
      end

    index = Enum.find_index(pieces, &(&1.square == old_pos))
    [piece] = Enum.filter(pieces, &(&1.square == old_pos))

    piece = %{piece | square: new_pos}

    List.replace_at(pieces, index, piece)
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:match, Chess.get_match!(id))}
  end

  defp page_title(:show), do: "Show Match"
  defp page_title(:edit), do: "Edit Match"
end
