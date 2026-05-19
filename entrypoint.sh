#!/bin/sh
set -e

if [ "$#" -gt 0 ] && [ "$1" != "tail" ]; then
    exec "$@"
fi

if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] || [ -n "${DISCORD_BOT_TOKEN:-}" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Hermes gateway..."
    exec hermes gateway
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Hermes container ready."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] No gateway tokens configured. Idle mode."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] To use Hermes: docker exec -it <container> bash"
exec tail -f /dev/null
