# Setup Guide

## Overview

The `setup` command provides an interactive way to configure your homelab services. Instead of manually editing `.env` files, you can answer a few simple questions and have your service configured automatically.

## Features

- **Interactive Configuration**: Answer simple questions instead of editing files
- **Domain or Port Selection**: Choose between domain-based access (via Traefik) or port-based access (localhost)
- **Port Validation**: Ensures port numbers are within the allowed range (3000-9000)
- **Cross-Platform Support**: Works on macOS, Linux, and Windows
- **Input Validation**: Ensures required values are provided and formatted correctly before creating configuration

## Usage

Navigate to any service directory and run:

```bash
make setup
```

## Configuration Options

### Option 1: Domain-Based Access (via Traefik with SSL)

When you select this option, you'll be prompted for:
- **Domain**: Your base domain (e.g., `example.com`)
- **Subdomain Prefix**: The subdomain for this service (e.g., `app`)

The service will be accessible at: `https://subdomain.example.com`

**Requirements:**
- Traefik must be configured and running
- DNS records must point to your server
- Cloudflare or other DNS provider configured for SSL certificates

### Option 2: Port-Based Access (localhost)

When you select this option:
- You'll be prompted to enter a port number between 3000-9000
- The port must be a valid number within this range
- The service will be accessible at: `http://localhost:PORT`

**Advantages:**
- No DNS configuration needed
- Works immediately
- Perfect for local development
- You choose your preferred port number

## Example Session

```
========================================
   Service Configuration Setup
========================================

How do you want to access this service?
  1) Domain (via Traefik with SSL)
  2) Port (localhost:PORT)

Enter your choice (1 or 2): 2

Port-based access selected

Please enter a port number between 3000 and 9000
Enter port number: 5432

✓ Configuration completed!
Service will be available at: http://localhost:5432

.env file created successfully!
You can now run 'make up' to start the service.
```

## Reconfiguration

If a `.env` file already exists, the command will ask if you want to reconfigure:

```
.env file already exists.
Do you want to reconfigure it? (y/N):
```

- Enter `y` to reconfigure
- Enter `n` or press Enter to keep existing configuration

## Technical Details

### Port Range

The default port range (3000-9000) is chosen to:
- Avoid system ports (< 1024)
- Avoid common service ports (e.g., 5432 for PostgreSQL, 6379 for Redis)
- Stay in the user port range
- Minimize conflicts with other services

### File Structure

The interactive setup is implemented in `setup-interactive.mk` and is automatically included by `common.mk`. It overrides the default `setup` target to provide interactive configuration.

### Environment Variables Modified

**For Domain-Based Access:**
- `DOMAIN`: Set to your domain
- `DOMAIN_PREFIX`: Set to your subdomain
- `HOST_PORT`: Cleared (empty)

**For Port-Based Access:**
- `HOST_PORT`: Set to selected port
- `DOMAIN`: Cleared (empty)
- `DOMAIN_PREFIX`: Cleared (empty)

## Troubleshooting

### Port Already in Use

If the port you entered is already in use:
1. Check which ports are currently in use: `netstat -an | grep LISTEN` (Linux/macOS) or `netstat -an | findstr LISTEN` (Windows)
2. Run `make setup` again and choose a different port
3. You can use `docker ps` to see which ports your Docker containers are using

### Domain Not Resolving

If you choose domain-based access but can't access the service:
1. Verify DNS records are correct
2. Run `make check-dns` to verify DNS configuration
3. Run `make dns` to add local hosts entry
4. Ensure Traefik is running: `cd traefik && make ps`

### Permission Errors

On macOS/Linux, you may need to make the Makefile executable:
```bash
chmod +x Makefile
```

## Next Steps

After running `setup`:

1. **Start the Service**: `make up` or `make run`
   > **Note**: Both commands require `.env` file. If it doesn't exist, you'll see an error with instructions.
2. **Check DNS** (for domain-based): `make check-dns`
3. **View Logs**: `make logs`
4. **Access the Service**: Use the URL provided during setup

## Command Reference

- `make setup` - Interactive configuration wizard
- `make up` / `make run` - Start containers (requires `.env` file)
- `make down` - Stop containers
- `make restart` - Restart containers
- `make logs` - View container logs
- `make ps` - List running containers
- `make clean` - Remove containers and volumes
- `make dns` - Add domain to hosts file
- `make check-dns` - Verify DNS configuration

## See Also

- [README.md](README.md) - Main repository documentation
- [CLAUDE.md](CLAUDE.md) - Development guidelines
- [common.mk](common.mk) - Common Makefile targets
