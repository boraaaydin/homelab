#!/bin/sh

# Exit on error
set -e

# Detect OS
case "$(uname -s)" in
    CYGWIN*|MINGW*|MSYS*|Windows_NT*)
        IS_WINDOWS=1
        ;;
    *)
        IS_WINDOWS=0
        ;;
esac

# Check if Docker is installed and running
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker daemon is running
if [ "$IS_WINDOWS" = "1" ]; then
    if ! docker info >/dev/null 2>&1; then
        echo "Docker daemon is not running. Please start Docker Desktop for Windows."
        exit 1
    fi
else
    if ! docker info >/dev/null 2>&1; then
        echo "Docker daemon is not running. Please start Docker first."
        exit 1
    fi
fi

# Create shared network if it doesn't exist
if ! docker network ls | grep -q "shared_network"; then
    echo "Creating shared_network..."
    if [ "$IS_WINDOWS" = "1" ]; then
        # Windows might not support overlay network, try bridge first
        if ! docker network create --driver bridge shared_network; then
            echo "Trying overlay network as fallback..."
            docker network create --driver overlay --attachable shared_network || {
                echo "Failed to create shared_network"
                exit 1
            }
        fi
    else
        docker network create --driver overlay --attachable shared_network || {
            echo "Failed to create shared_network"
            exit 1
        }
    fi
    echo "Successfully created shared_network"
else
    echo "Docker network 'shared_network' already exists."
fi