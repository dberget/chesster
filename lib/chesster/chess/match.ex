defmodule Chesster.Chess.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [])
    |> validate_required([])
  end
end
