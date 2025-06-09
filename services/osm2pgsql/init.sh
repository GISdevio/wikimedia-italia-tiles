#!/bin/bash

set -eu

psql -v ON_ERROR_STOP=on -f functions.sql

osm2pgsql \
    --cache=20000 \
    --flat-nodes=/data/cache/nodes.bin \
    --slim `# needed by osm2pgsql-replication` \
    --output flex \
    --style openstreetmap-carto-flex.lua \
    --input-reader=pbf "$INITIAL_PBF"

osm2pgsql-replication init --server "$REPLICATION_URL"