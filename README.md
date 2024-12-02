# Wikimedia Italia OSM tiles

Custom OSM tiles for Wikimedia Italia.

Software under development.

# How to run

## Initialization

Download `planet-latest.osm-pbf` into `data/init/`.

```bash
docker compose build
docker compose --profile init build
docker compose --profile init run --rm import
docker compose --profile init run --rm external-data
docker compose --profile init down
```

## Run

```bash
docker compose up -d
```