defmodule Upcoming.Repo do
  use Ecto.Repo,
    otp_app: :upcoming_elixir,
    adapter: Ecto.Adapters.Postgres
end
