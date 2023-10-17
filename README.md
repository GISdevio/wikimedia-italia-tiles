# Wikimedia Italia OSM tiles

Custom OSM tiles for Wikimedia Italia.

Software under development.

## How to run

```bash
docker compose build
docker compose up postgres --detach
(cd openstreetmap-carto/ && fades -d psycopg2 -d pyyaml -d requests scripts/get-external-data.py -H localhost -d osm -U osm -w test_password) # initialization
python3 openstreetmap-carto/scripts/indexes.py | docker exec -i "$(docker container ls -qf name=wikimedia-italia-tiles-postgres-1)" psql
docker compose up --detach
```
