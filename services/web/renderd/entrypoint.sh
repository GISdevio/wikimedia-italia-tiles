#!/bin/bash

set -euo pipefail

# https://cartocss.readthedocs.io/en/latest/mml.html#datasource
for file in carto/project.xml `# hiking/project.xml`
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

exec "$@"
