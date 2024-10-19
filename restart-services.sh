#!/bin/bash

COMPOSE_FILE="docker-compose.yaml"
NETWORK_NAME="vpn-network"

# Maximum number of retries
MAX_RETRIES=5
RETRY_COUNT=0

cd /home/server/server/

echo "=== Stopping tailscale ==="
tailscale down --accept-risk=lose-ssh
tailscale status

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    echo "=== Attempt $((RETRY_COUNT + 1)) of $MAX_RETRIES ==="

    echo "=== Stopping docker services ==="
    docker compose down
    echo "=== Waiting 2 seconds for networks to be released ==="
    sleep 1
    echo "=== Waiting 1 seconds for networks to be released ==="
    sleep 1

    docker compose -f $COMPOSE_FILE up -d

    # Check if the previous command was successful
    if [ $? -eq 0 ]; then
        echo "=== docker compose up succeeded ==="
        echo "=== Starting tailscale ==="
        tailscale up
        tailscale status
        exit 0
    else
        echo "=== docker compose up failed. Retrying... ==="
        docker compose down
        # Increment retry count
        RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
done

echo "=== Reached maximum retries. docker compose up failed ==="
tailscale up
tailscale status
exit 1
