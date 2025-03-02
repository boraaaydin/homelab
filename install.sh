#!/bin/bash

if [ -f .env ]; then
    export $(grep -E '^HOMEDOMAIN=' .env | xargs)
else
    echo ".env file not found!"
fi

echo "HOMEDOMAIN set to: $HOMEDOMAIN"

docker network create --driver overlay --attachable shared_network
