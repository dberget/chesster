defmodule Chesster do
  @moduledoc """
  """

  def init(id) do
    if game_running?(id) do
      IO.inspect("__GAME_EXISTS___")
    else
      {:ok, pid} = :binbo.new_server()

      IO.inspect("__STARTING_GAME__")
      start_game(pid)

      Registry.register(:chesster, id, pid)
    end
  end

  def start_game(pid) do
    :binbo.new_uci_game(pid, %{engine_path: "/usr/local/Cellar/stockfish/11/bin/stockfish"})
  end

  def play(id, move, :player_vs_computer) do
    [{_pid, pid}] = Registry.match(:chesster, id, :"$1")

    case :binbo.move(pid, move) do
      {:ok, _status} ->
        next_move(pid)

      {:error, reason} ->
        IO.inspect(reason, label: "error")
        {:error, reason}
    end
  end

  def play(id, move, :player_vs_player) do
    [{_pid, pid}] = Registry.match(:chesster, id, :"$1")

    case :binbo.move(pid, move) do
      {:ok, status} ->
        {:ok, :player, status}

      {:error, reason} ->
        IO.inspect(reason, label: "error")
        {:error, reason}
    end
  end

  def next_move(pid) do
    :binbo.uci_sync_position(pid)

    :binbo.uci_play(pid, %{})
  end

  def fen(id) do
    [{_pid, pid}] = Registry.match(:chesster, id, :"$1")

    :binbo.get_fen(pid)
  end

  def print_board(id) do
    [{_pid, pid}] = Registry.match(:chesster, id, :"$1")

    :binbo.print_board(pid)
  end

  def game_running?(id) do
    case Registry.match(:chesster, id, :"$1") do
      [{_pid, _pid2}] ->
        true

      [] ->
        false
    end
  end
end
