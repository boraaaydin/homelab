#!/bin/bash

if ! docker network ls | grep -q "shared_network"; then
    docker network create --driver overlay --attachable shared_network
else
    echo "Docker network 'shared_network' already exists."
fi