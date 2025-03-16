#!/bin/bash

docker swarm init
docker network create --driver overlay --attachable shared_network
