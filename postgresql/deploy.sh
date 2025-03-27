#!/bin/bash

docker compose -f ../traefik/docker-compose.yml up -d

docker compose -f docker-compose-17.yml up -d