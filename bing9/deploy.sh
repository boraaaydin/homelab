#!/bin/bash

docker stack deploy --compose-file ../traefik/docker-stack.yml traefik

docker stack deploy --compose-file docker-stack.yml bind9
