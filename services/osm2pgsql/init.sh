#!/bin/bash

set -eu

osm2pgsql \
    --cache=20000 \
    --flat-nodes=/data/cache/nodes.bin \
    --slim `# needed by osm2pgsql-replication` \
    --multi-geometry \
    --hstore \
    --style openstreetmap-carto.style \
    --tag-transform-script openstreetmap-carto.lua \
    --input-reader=pbf "$INITIAL_PBF"

osm2pgsql-replication init --server "$REPLICATION_URL"