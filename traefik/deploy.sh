#!/bin/bash

mkdir -p data/etc
mkdir -p data/log

docker stack deploy --compose-file docker-stack.yml traefik