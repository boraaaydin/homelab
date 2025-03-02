#!/bin/bash

if [ -f .env ]; then
    eval $(grep -E '^HOMEDOMAIN=' .env)
    echo "HOMEDOMAIN set to: $HOMEDOMAIN"
else
    echo ".env file not found!"
fi

echo "HOMEDOMAIN: $HOMEDOMAIN"


docker network create --driver overlay --attachable shared_network
