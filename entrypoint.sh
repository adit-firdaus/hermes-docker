#!/bin/bash
set -e

if [ "$#" -gt 0 ] && [ "$1" != "tail" ]; then
    exec "$@"
fi

if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] || [ -n "${DISCORD_BOT_TOKEN:-}" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Hermes gateway..."
    exec hermes gateway
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Hermes agent container started."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] No gateway tokens configured. Running in idle mode."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] To use Hermes interactively: docker exec -it hermes-agent bash"
exec tail -f /dev/null
