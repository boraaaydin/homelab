## Swarm
- docker service update --force pihole_pihole
- docker service logs pihole_pihole
- docker inspect service pihole_pihole
- docker service inspect pihole_pihole | jq .[].Spec.Labels
- docker exec -it $(docker ps -qf "name=pihole") ls

- docker service update --force traefik_traefik
- docker service logs traefik_traefik
- docker inspect service traefik_traefik

## Traefik
- curl http://localhost:8080/api/rawdata

## Networking
- nslookup pihole.home.boraaydin.com 192.168.68.62


