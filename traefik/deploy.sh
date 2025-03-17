#!/bin/bash

BASE_DIR="$(dirname "$(readlink -f "$0")")"

mkdir -p "$BASE_DIR/data/etc"
mkdir -p "$BASE_DIR/data/certs"
mkdir -p "$BASE_DIR/data/log"

docker stack deploy --compose-file docker-stack.yml traefik