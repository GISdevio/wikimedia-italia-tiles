#!/bin/sh

set -eu

while ! pg_isready
do
    sleep 1
done

exec "$@"
