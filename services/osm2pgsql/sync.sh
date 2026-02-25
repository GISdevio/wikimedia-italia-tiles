#!/bin/sh

set -eu

# check if data has been imported
if [ "$(psql -Atc "select exists (select * from pg_tables where schemaname='public' and tablename='planet_osm_ways')")" = 'f' ]
then
    osm2pgsql \
        --cache=20000 \
        --flat-nodes=/data/cache/nodes.bin \
        --slim \
        --output flex \
        --style all_styles.lua \
        --input-reader=pbf "$INITIAL_PBF"
fi

osm2pgsql-replication init --server "$REPLICATION_URL"

while true
do
    osm2pgsql-replication update -- \
        --cache=20000 \
        --flat-nodes=/data/cache/nodes.bin \
        --append \
        --slim \
        --output flex \
        --style all_styles.lua \
    || echo "Update failed, retrying in 1 hour.."
    # Reconcile is_hiking status
    psql -v ON_ERROR_STOP=on -f ./osmita-hiking/scripts/triggers.sql
    sleep 1h
done