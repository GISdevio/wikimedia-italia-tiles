# Wikimedia Italia OSM tiles

Custom OSM tiles for Wikimedia Italia.

Software under development.

## How to run

Download the planet or the extract in avance and modify `docker-compose.yml` accordingly.

```bash
docker compose build
docker compose --profile init run --rm external-data
docker compose --profile init run --rm import
docker compose up -d
```