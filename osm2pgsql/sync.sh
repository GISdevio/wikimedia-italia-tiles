#!/bin/bash

set -euo pipefail

# check if data has been imported
if ! psql -AXqtc "select 'public.planet_osm_ways'::regclass" 2>/dev/null
then
    wget -O- -nv "$INITIAL_PBF" |
        osm2pgsql \
            --slim `# needed by osm2pgsql-replication` \
            --multi-geometry \
            --hstore \
            --style openstreetmap-carto.style \
            --tag-transform-script openstreetmap-carto.lua \
            --input-reader=pbf -
    osm2pgsql-replication init --server "$REPLICATION_URL"
fi

while [ $? ]
do
  osm2pgsql-replication update
  sleep 1h
done
