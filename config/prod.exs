import Config

config :wildfires, Wildfires.Repo, hostname: "postgres"

config :opentelemetry_exporter,
  otlp_compression: :gzip,
  otlp_endpoint: "http://localhost:4318"
