#!/bin/bash

if [ -f .env ]; then
    eval $(grep -E '^HOMEDOMAIN=' .env)
else
    echo ".env file not found!"
fi

echo "HOMEDOMAIN set to: $HOMEDOMAIN"

docker network create --driver overlay --attachable shared_network
