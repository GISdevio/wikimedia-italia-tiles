#!/bin/bash

set -euo pipefail

./scripts/get-external-data.py --cache --data /data -H postgres -d osm -U osm -w test_password
./scripts/indexes.py --concurrent --concurrent --notexist | psql -v ON_ERROR_STOP=on