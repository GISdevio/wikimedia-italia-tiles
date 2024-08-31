#!/bin/bash

set -euo pipefail

# https://cartocss.readthedocs.io/en/latest/mml.html#datasource
for file in carto/project.xml hiking/project.xml
do
  xmlstarlet ed --inplace \
    -u "/Map/Layer/Datasource/Parameter[@name='dbname']" -v "$PGDATABASE" \
    -s "/Map/Layer/Datasource" -t elem -n "Parameter" -v "$PGHOST" \
    -i "/Map/Layer/Datasource/Parameter[last()]"  -t attr -n "name" -v "host" \
    -s "/Map/Layer/Datasource" -t elem -n "Parameter" -v "$PGUSER" \
    -i "/Map/Layer/Datasource/Parameter[last()]"  -t attr -n "name" -v "user" \
    -s "/Map/Layer/Datasource" -t elem -n "Parameter" -v "$PGPASSWORD" \
    -i "/Map/Layer/Datasource/Parameter[last()]"  -t attr -n "name" -v "password" \
    "$file"
done

while ! pg_isready
do
    sleep 1
done

# from openstreetmap-carto external-data.yml + planet
for layer in \
  simplified_water_polygons water_polygons icesheet_polygons icesheet_outlines ne_110m_admin_0_boundary_lines_land \
  planet_osm_point planet_osm_line planet_osm_ways planet_osm_roads planet_osm_rels planet_osm_polygon
do
  while ! [ $(psql -Atc "select exists (select * from pg_tables where schemaname='public' and tablename='${layer}')") == 't' ]
  do
    sleep 1
  done
done

exec "$@"
