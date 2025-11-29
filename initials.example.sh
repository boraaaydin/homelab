#!/bin/bash

echo "Starting homelab services..."

# Function to start a service
start_service() {
    local service_name=$1

    echo "Starting $service_name..."
    cd "$service_name"
    make up
    cd ..
}

# Start Docker Desktop if not running
echo "Checking Docker status..."
if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running. Starting Docker Desktop..."
    open -a Docker

    # Wait for Docker to be ready
    echo "Waiting for Docker to be ready..."
    while ! docker info >/dev/null 2>&1; do
        sleep 5
        echo "Still waiting for Docker..."
    done
    echo "Docker is ready!"
fi

# Set the Docker context to default
docker context use default

# Start core services first
echo "Starting core infrastructure services..."
start_service "rabbitmq"
start_service "ory-hydra"
start_service "mongo"
start_service "valkey"
start_service "postgresql"

# Wait for core services to be ready
echo "Waiting 120 seconds for core services to be ready..."
sleep 120

# Start dependent services
echo "Starting dependent services..."
start_service "mongo-express"
start_service "redis-commander"
start_service "miniflux"
cd 