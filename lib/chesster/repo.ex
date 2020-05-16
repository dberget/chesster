defmodule Chesster.Repo do
  use Ecto.Repo,
    otp_app: :chesster,
    adapter: Ecto.Adapters.Postgres
end
