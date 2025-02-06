import Config

config :wildfires, Wildfires.Repo,
  database: "wildfires_repo_#{Mix.env()}",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :wildfires,
  ecto_repos: [Wildfires.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
