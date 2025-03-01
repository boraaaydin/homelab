#!/bin/bash

if [ -f .env ]; then
    export $(grep -E '^HOMEDOMAIN=' .env | xargs)
    echo "HOMEDOMAIN set to: $HOMEDOMAIN"
else
    echo ".env file not found!"
fi


docker network create --driver overlay --attachable shared_network
