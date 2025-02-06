import Config

config :wildfires, Wildfires.Repo,
  database: "wildfires_repo_#{Mix.env()}",
  username: "postgres",
  password: "postgres",
  hostname: "postgres"
