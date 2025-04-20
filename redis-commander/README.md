# Redis Commander

A web management tool for Redis, deployed using Docker Compose.

## Features

- Web interface for Redis database management
- Secure access with authentication
- Traefik integration for HTTPS
- Health checks for container monitoring

## Requirements

- Docker and Docker Compose
- Traefik reverse proxy (configured separately)
- Shared Docker network (named `shared_network`)

## Setup

1. Clone this repository
2. Set up your environment variables:
   ```bash
   make setup
   ```
3. Edit the `.env` file with your specific configurations
4. Start the service:
   ```bash
   make up
   ```

For local development, you might need to add a DNS entry:
```bash
# On macOS/Linux
make dns-mac
# or
make dns-linux

# On Windows (run PowerShell as Administrator)
make dns-windows
```

## Usage

Once the service is running, access Redis Commander through your browser:
- https://redis-commander.yourdomain.com (with proper DNS configuration)
- http://localhost:8082 (if using port exposure with `make up-with-ports`)

Log in with the credentials you configured in the `.env` file.

## Commands

Use the following make commands for management:

- `make help` - Display available commands
- `make setup` - Set up the application
- `make up` - Start services
- `make up-with-ports` - Start services with port forwarding
- `make down` - Stop services
- `make restart` - Restart services
- `make logs` - View logs
- `make ps` - Check service status
- `make clean` - Remove containers and volumes
- `make test-healthcheck` - Test the container healthcheck

## Configuration

The main configuration is done via environment variables in the `.env` file:

- `REDIS_HOST` - Hostname or IP address of Redis server (default: valkey)
- `REDIS_PORT` - Port of Redis server (default: 6379)
- `REDIS_PASSWORD` - Password for Redis connection
- `HTTP_USER` - Username for Redis Commander
- `HTTP_PASSWORD` - Password for Redis Commander
- `DOMAIN_PREFIX` - Subdomain for the service
- `DOMAIN` - Main domain name
- `HOST_PORT` - Port number for local access (default: 8082)

## Note

By default, Redis Commander is configured to connect to a Redis/Valkey service. If you need to override the default connection settings, modify the `REDIS_HOST` and `REDIS_PORT` variables in your `.env` file. 