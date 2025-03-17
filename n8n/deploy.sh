#!/bin/bash

# docker stack deploy --compose-file ../traefik/docker-stack.yml traefik
sh ../traefik/deploy.sh

docker stack deploy --compose-file docker-stack.yml n8n