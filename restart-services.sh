#!/bin/bash

COMPOSE_FILE="docker-compose.yaml"

cd /home/server/server/
echo "=== Stopping docker services ==="
docker compose down
echo "=== Waiting 1 second for networks to be released ==="
sleep 1
docker compose -f $COMPOSE_FILE up -d
