import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: :all

config :wildfires, Wildfires.Repo,
  database: "wildfires_repo_#{Mix.env()}",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :wildfires,
  ecto_repos: [Wildfires.Repo]

config :opentelemetry,
  resource: %{service: %{name: "wildfires"}},
  span_processor: :batch,
  traces_exporter: :otlp

config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_endpoint: "http://localhost:4318"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
