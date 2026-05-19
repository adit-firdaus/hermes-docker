#!/bin/sh

# Forward SIGTERM/SIGINT to the gateway so Dokploy can stop the container cleanly
cleanup() {
    kill -TERM "$GATEWAY_PID" 2>/dev/null
    wait "$GATEWAY_PID" 2>/dev/null
    exit 0
}

trap cleanup TERM INT

if [ "$#" -gt 0 ] && [ "$1" != "tail" ]; then
    exec "$@"
fi

while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Hermes gateway..."

    # Fix ownership of config files created during root docker exec sessions
    chown -R hermes:hermes /opt/data 2>/dev/null || true

    # Run gateway in background so this script stays PID 1
    /opt/hermes/docker/entrypoint.sh hermes gateway &
    GATEWAY_PID=$!

    # Wait for gateway to exit
    wait "$GATEWAY_PID"
    STATUS=$?

    # If we got SIGTERM/INT, cleanup() already exited us
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Gateway exited with code $STATUS. Restarting in 3s..."
    sleep 3
done
