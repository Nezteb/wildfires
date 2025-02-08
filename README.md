# Wildfires

Setup commands:
```
# Build
mix deps.get
mix compile

# Start dependencies and run tests
docker compose up --detach \
  --remove-orphans \
  --renew-anon-volumes \
  --force-recreate \
  postgres otel jaeger

mix ecto.create 

mix test

# Run app in container
docker compose up --build wildfires

# Debugging:
iex -S mix
# or
iex -S mix run --no-start
```

### Links

- https://www.arcgis.com/home/item.html?id=d957997ccee7408287a963600a77f61f
- https://services9.arcgis.com/RHVPKKiFTONKtxq3/arcgis/rest/services/USA_Wildfires_v1/FeatureServer
- https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service/
- https://hex.pm/packages/bandit
- https://epsg.io/4326

### TODO

- [?] Perimeter data
  - What does this mean?
- [X] Packaging and deployment plan
- [X] Telemetry/Monitoring of workload
- [X] UI to visualize current fires
- [~] Unit/Integration tests
  - In progress
