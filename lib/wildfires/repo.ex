defmodule Wildfires.Repo do
  use Ecto.Repo,
    otp_app: :wildfires,
    adapter: Ecto.Adapters.Postgres
end
