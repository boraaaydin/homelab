#!/bin/bash

export $(grep -v '^#' ../.env | xargs -d '\n')

docker stack deploy --compose-file ../traefik/docker-stack.yml traefik

docker stack deploy --compose-file docker-stack.yml pihole
