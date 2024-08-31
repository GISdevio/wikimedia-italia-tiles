#!/bin/bash

set -euo pipefail

# check if data has been imported
if [ $(psql -Atc "select exists (select * from pg_tables where schemaname='public' and tablename='planet_osm_ways')") == 'f' ]
then
    wget -O- -nv "$INITIAL_PBF" |
        osm2pgsql \
            --slim `# needed by osm2pgsql-replication` \
            --multi-geometry \
            --hstore \
            --style openstreetmap-carto.style \
            --tag-transform-script openstreetmap-carto.lua \
            --number-processes 16 \
            --input-reader=pbf -
fi

osm2pgsql-replication init --server "$REPLICATION_URL"

while [ $? ]
do
    osm2pgsql-replication update -- \
        --append \
        --slim \
        --multi-geometry \
        --hstore \
        --style openstreetmap-carto.style \
        --tag-transform-script openstreetmap-carto.lua
    sleep 1h
done