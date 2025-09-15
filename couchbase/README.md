# Couchbase

Couchbase NoSQL database service for the homelab infrastructure.

## Quick Start

```bash
# Setup environment
make setup

# Edit .env with your configuration
nano .env

# Start services
make up
```

## Access

- **Admin Console**: http://localhost:8091
- **Views**: http://localhost:8092
- **Query**: http://localhost:8093
- **Search**: http://localhost:8094
- **Data**: Port 11210

## Configuration

Copy `.env.example` to `.env` and configure:

```bash
# Domain-based access (requires Traefik)
DOMAIN_PREFIX=couchbase
DOMAIN=yourdomain.com

# Localhost access
HOST_PORT=8091
```

## Dependencies

- **shared_network**: Docker network (created by root `make install`)
- **Traefik**: Reverse proxy (for domain-based access)

## Commands

- `make setup` - Create .env from template
- `make up` - Start Couchbase
- `make down` - Stop Couchbase
- `make restart` - Restart services
- `make logs` - View logs
- `make clean` - Remove containers and volumes
- `make dns-mac/linux/windows` - Configure local DNS