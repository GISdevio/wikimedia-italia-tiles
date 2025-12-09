#!/bin/bash
set -eu

export APACHE_CONFDIR=/etc/apache2
source /etc/apache2/envvars

exec "$@"