# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a homelab infrastructure repository containing Docker-based self-hosted applications with automated SSL certification and reverse proxy capabilities. The repository follows a service-oriented architecture where each application is containerized and managed independently.

### Core Structure
- Each application lives in its own directory with dedicated `docker-compose.yml` and `Makefile`
- **Traefik** serves as the central reverse proxy and SSL certificate manager
- **shared_network** Docker network connects all services
- Applications can be accessed via domain names (with SSL) or localhost ports
- Configuration uses `.env` files based on `.env.example` templates

### Key Infrastructure Components
- **traefik/**: Central reverse proxy with Cloudflare DNS challenge for SSL
- **authentic/**: Identity and Access Management (Authentik)
- **postgresql/**: Primary database for applications requiring PostgreSQL
- **valkey/**: Redis-compatible in-memory data store
- **minio/**: S3-compatible object storage
- **ory-hydra/**: OAuth2 provider with PostgreSQL backend

## Common Development Commands

### Global Setup
```bash
# Initial setup - creates shared Docker network
make install

# Clean all project containers
make clean
```

### Per-Application Commands
Navigate to any application directory and use:
```bash
# Show available commands
make

# Setup application (copies .env.example to .env, generates secrets if needed)
make setup

# Start services
make up

# Stop services  
make down

# Restart services
make restart

# View logs
make logs

# Clean application data
make clean
```

### DNS Configuration
For local development without a domain:
```bash
# Add local DNS entries (run from application directory)
make dns-mac     # macOS
make dns-linux   # Linux  
make dns-windows # Windows (shows manual instructions)
```

## Environment Configuration

Each application requires a `.env` file created from `.env.example`. Common patterns:

### Domain-based Access
```
DOMAIN_PREFIX=appname
DOMAIN=example.com
# Access: appname.example.com
```

### Localhost Access
```
HOST_PORT=8080
# Access: localhost:8080
```

### Traefik Configuration
The traefik service requires Cloudflare credentials:
```
CLOUDFLARE_DNS_API_TOKEN=your_token
CLOUDFLARE_API_EMAIL=your_email
CUSTOMDOMAIN=your_domain.com
```

## Service Dependencies

Most applications depend on the shared infrastructure:
1. **shared_network** Docker network (created by root `make install`)
2. **Traefik** for reverse proxy and SSL (if using domain access)
3. **PostgreSQL** for applications requiring database storage
4. **Valkey/Redis** for caching and session storage

## Development Workflow

1. Run `make install` from repository root to create shared network
2. Configure Traefik first if using domain-based access
3. For each application:
   - Copy `.env.example` to `.env` and configure
   - Run `make setup` if available (generates secrets)
   - Configure DNS records or local hosts entries
   - Run `make up` to start services
4. Access applications via configured domain or localhost port

## Port Allocation Strategy

Applications use two Docker Compose configurations:
- `docker-compose.yml`: Domain-based access (no exposed ports)
- `docker-compose.ports.yml`: Localhost access (with HOST_PORT mapping)

The Makefile automatically selects the appropriate configuration based on environment variables.

- Always use rules in `.cursorrules`
- Use Default docker context in make files