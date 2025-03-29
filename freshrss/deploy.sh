#!/bin/bash

docker compose -f ../traefik/docker-compose.yml up -d

# docker compose -f ../postgresql/docker-compose.yml up -d

# # PostgreSQL'in hazır olmasını bekle
# echo "PostgreSQL'in hazır olması bekleniyor..."
# until docker exec $(docker ps -q -f name=postgres) pg_isready; do
#   echo "PostgreSQL hazır değil, 5 saniye sonra tekrar denenecek..."
#   sleep 5
# done
# echo "PostgreSQL hazır!"

docker compose -f docker-compose.yml up -d