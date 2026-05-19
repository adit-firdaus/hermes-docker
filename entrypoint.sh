#!/bin/sh
set -e

if [ "$#" -gt 0 ] && [ "$1" != "tail" ]; then
    exec "$@"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Hermes gateway..."

# Delegate to the official entrypoint which drops privileges to the 'hermes' user
exec /opt/hermes/docker/entrypoint.sh hermes gateway
