# Wikimedia Italia OSM tiles

Custom OSM tiles for Wikimedia Italia.

Software under development.

# How to run

## Initialization

Download `planet-latest.osm-pbf` into `data/init/`.
Populate `data/hiking/` with `contour.geojson` and the `.tif` files required by the hiking style.

Copy the example env file:

```bash
cp env.example .env
```

Write the email address that should be used to generate the SSL certificates in `.env`, as well as the domanin name.
Consider changing Postgres username and password.

Populate the database:

```bash
docker compose build
docker compose --profile init build
docker compose --profile init run --rm import
docker compose --profile init down
```

## Run

```bash
docker compose up -d
```