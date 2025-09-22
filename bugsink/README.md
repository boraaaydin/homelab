# Bugsink

Python error tracking and monitoring tool similar to Sentry. Bugsink provides a clean interface for tracking application errors and exceptions with detailed stack traces and analytics.

## Quick Start

```bash
# Initial setup
make setup

# Configure environment variables in .env
# Start services
make up

# Access via domain (requires Traefik)
https://bugsink.example.com

# Or access via localhost (set HOST_PORT in .env)
http://localhost:8000
```

## Configuration

Copy `.env.example` to `.env` and configure:

### Domain Access
```bash
DOMAIN_PREFIX=bugsink
DOMAIN=example.com
BEHIND_HTTPS_PROXY=true
```

### Localhost Access
```bash
HOST_PORT=8000
BEHIND_HTTPS_PROXY=false
```

### Application Settings
- `SECRET_KEY`: Django secret key (generate with `openssl rand -base64 50`)
- `CREATE_SUPERUSER`: Initial admin user (format: `username:password`)
- `BUGSINK_VERSION`: Docker image version
- `BUGSINK_PORT`: Internal container port

## Dependencies

### Required Infrastructure
1. **shared_network**: Docker network for service communication
2. **PostgreSQL**: Database backend (configured via DB_* variables)

### Optional Infrastructure
- **Traefik**: For domain-based access with SSL
- DNS configuration: For custom domain access

## Database Setup

Bugsink uses the shared PostgreSQL instance. Ensure:
1. PostgreSQL service is running
2. Database `bugsink` exists
3. User `bugsinkuser` has access to the database

```bash
# Create database and user in PostgreSQL
CREATE DATABASE bugsink;
CREATE USER bugsinkuser WITH PASSWORD 'your_super_secret_password';
GRANT ALL PRIVILEGES ON DATABASE bugsink TO bugsinkuser;
```

## Usage

### Basic Commands
```bash
make up          # Start Bugsink
make down        # Stop Bugsink
make restart     # Restart services
make logs        # View logs
make clean       # Remove containers and volumes
```

### DNS Configuration
```bash
make dns-mac     # Add local DNS entry (macOS)
make dns-linux   # Add local DNS entry (Linux)
make dns-windows # Show Windows DNS instructions
```

## Features

- **Error Tracking**: Automatic collection of Python exceptions
- **Stack Traces**: Detailed error context and stack information
- **Performance Monitoring**: Track slow operations and bottlenecks
- **User Context**: Associate errors with users and sessions
- **Custom Tags**: Organize errors with custom metadata
- **Email Notifications**: Alert on critical errors
- **API Integration**: RESTful API for custom integrations

## Integration

Configure your Python applications to send errors to Bugsink:

```python
import bugsink

bugsink.init('https://bugsink.example.com/api/key/your-project-key/')
```

## Ports

- **8000**: Web interface and API
- **5432**: PostgreSQL (shared service)

## Volumes

- `bugsink_data`: Application data and uploads