export $(grep -v '^#' .env | xargs -d '\n')

docker network create --driver overlay --attachable shared-network
