import Config

config :wildfires, Wildfires.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :wildfires,
  api: [
    plug: {Req.Test, Wildfires.HTTPClient}
  ]
