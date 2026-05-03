# OWASP ZAP - Zed Attack Proxy

OWASP ZAP (Zed Attack Proxy) is a free, open-source web application security scanner. This setup provides browser-based GUI access through Docker.

## Features

- Browser-based web GUI (via Webswing)
- Automated SSL certificate generation for HTTPS interception
- Proxy functionality for security testing
- Automated setup with Traefik integration or localhost access

## Quick Start

### 1. Initial Setup

```bash
# Interactive setup (recommended)
make setup

# Or manual setup
cp .env.example .env
# Edit .env with your configuration
```

### 2. Start ZAP

```bash
make up
```

### 3. Access ZAP Web GUI

**Domain-based access** (with Traefik):
- URL: `https://zap.yourdomain.com/zap`
- Configure DOMAIN_PREFIX and CUSTOMDOMAIN in .env
- Run `make dns` to add local DNS entry

**Localhost access**:
- URL: `http://localhost:8080/zap`
- Set HOST_PORT=8080 in .env

## HTTPS Interception Setup

ZAP automatically generates SSL certificates in the `./data/` directory:

1. **Find the certificate**: `./data/zap_root_ca.crt`
2. **Import to your browser**:
   - **Chrome/Edge**: Settings → Privacy and security → Security → Manage certificates → Authorities → Import
   - **Firefox**: Settings → Privacy & Security → View Certificates → Authorities → Import
3. **Configure your browser's proxy**:
   - HTTP Proxy: `localhost` (or container IP)
   - Port: `8090` (or your ZAP_PROXY_PORT)

## Configuration

Edit `.env` file to customize:

```bash
# Domain access
DOMAIN_PREFIX=zap
CUSTOMDOMAIN=yourdomain.com

# Or localhost access
HOST_PORT=8080

# ZAP version (stable, weekly, nightly)
ZAP_VERSION=stable

# Proxy port
ZAP_PROXY_PORT=8090
```

## Available Commands

```bash
make setup      # Interactive setup
make up         # Start ZAP
make down       # Stop ZAP
make restart    # Restart ZAP
make logs       # View logs
make ps         # List containers
make clean      # Remove containers and data
make dns        # Add DNS entry to hosts file
```

## Security Notes

- ZAP is a security testing tool - only use it on applications you have permission to test
- The web interface has no authentication by default - restrict access appropriately
- Certificates are stored in `./data/` - keep them secure

## Data Persistence

All ZAP data, including:
- SSL certificates (`zap_root_ca.crt`, `zap_root_ca.key`)
- Session data
- Scan results

...are stored in the `./data/` directory and persist across container restarts.

## Troubleshooting

**Web UI not loading?**
- Wait 60 seconds for ZAP to fully start
- Check logs: `make logs`
- Verify health: `docker ps` (should show "healthy")

**Certificate errors in browser?**
- Ensure you imported `zap_root_ca.crt` to browser
- Restart browser after importing certificate
- Check certificate is in Authorities/Root CAs section

**Proxy not working?**
- Verify browser proxy settings point to correct port
- Ensure ZAP is running: `make ps`
- Check ZAP_PROXY_PORT in .env matches browser settings

## Documentation

- [ZAP Docker Documentation](https://www.zaproxy.org/docs/docker/about/)
- [ZAP Webswing Guide](https://www.zaproxy.org/docs/docker/webswing/)
- [ZAP User Guide](https://www.zaproxy.org/docs/)
