#!/bin/bash

mkdir -p data/etc
mkdir -p data/certs
mkdir -p data/log

# docker stack deploy --compose-file docker-stack.yml traefik
docker compose up -d