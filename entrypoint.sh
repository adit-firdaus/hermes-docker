#!/bin/sh
set -e

if [ "$#" -gt 0 ] && [ "$1" != "tail" ]; then
    exec "$@"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Hermes gateway..."
exec hermes gateway
