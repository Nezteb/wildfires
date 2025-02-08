import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
partition = System.get_env("MIX_TEST_PARTITION")

config :wildfires, Wildfires.Repo,
  database: "wildfires_repo_#{Mix.env()}#{partition}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :wildfires,
  api: [
    plug: {Req.Test, Wildfires.HTTPClient}
  ]

config :opentelemetry,
  traces_exporter: :none

config :opentelemetry, :processors, [
  {:otel_simple_processor, %{}}
]
