#!/bin/bash

set -euo pipefail

while ! pg_isready
do
    sleep 1
done

exec "$@"
