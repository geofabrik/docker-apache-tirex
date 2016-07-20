#!/bin/bash

set -e
echo "host = $1"
host="$1"
echo $host
shift
cmd="$@ $1"

until psql -h "$host" -U "postgres" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 10
done

>&2 echo "Postgres is up - executing command"
exec $cmd
