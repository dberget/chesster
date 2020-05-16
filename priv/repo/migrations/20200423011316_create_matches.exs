defmodule Chesster.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      timestamps()
    end
  end
end
