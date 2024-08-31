# Wikimedia Italia OSM tiles

Custom OSM tiles for Wikimedia Italia.

Software under development.

## How to run

```bash
docker compose build
docker compose up
```

## Notes

```bash
python3 openstreetmap-carto/scripts/indexes.py | docker exec -i "$(docker container ls -qf name=wikimedia-italia-tiles-postgres-1)" psql # is it needed?
```

https://github.com/openstreetmap/mod_tile/blob/2577716b0ffcd164c62e33b305e56430cece6bd1/etc/apache2/renderd-example-map.conf#L112
