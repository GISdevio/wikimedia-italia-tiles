#!/bin/bash

set -euo pipefail

./scripts/get-external-data.py --cache --data /data -H $PGHOST -d $PGDATABASE -U $PGUSER -w $PGPASSWORD
./scripts/indexes.py --concurrent --notexist | psql -v ON_ERROR_STOP=on