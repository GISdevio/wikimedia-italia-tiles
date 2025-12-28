#!/bin/sh

set -eu

cd osmita-carto/
./scripts/get-external-data.py --cache --data /data/external -H $PGHOST -d $PGDATABASE -U $PGUSER -w $PGPASSWORD
psql -v ON_ERROR_STOP=on -f ./functions.sql
cd ../

cd osmita-hiking/
ogr2ogr -if GeoJSONSeq -of PostgreSQL "PG:host=$PGHOST dbname=$PGDATABASE user=$PGUSER password=$PGPASSWORD" /vsigzip//data/hiking/contour.jsonl.gz -nln public.contour -overwrite
cd ../

osm2pgsql \
    --number-processes 8 \
    --cache=20000 \
    --flat-nodes=/data/cache/nodes.bin \
    --slim `# needed by osm2pgsql-replication` \
    --output flex \
    --style all_styles.lua \
    --input-reader=pbf "$INITIAL_PBF"

cd osmita-carto/
./scripts/indexes.py --concurrent --notexist | psql -v ON_ERROR_STOP=on
cd ../

cd osmita-hiking/
psql -v ON_ERROR_STOP=on -f ./scripts/triggers.sql
psql -v ON_ERROR_STOP=on -f ./scripts/indexes.sql
psql -v ON_ERROR_STOP=on -f ./scripts/db_function.sql
cd ../

osm2pgsql-replication init --server "$REPLICATION_URL"