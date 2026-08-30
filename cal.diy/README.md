# Cal.com

Open source scheduling and booking platform, a self-hosted alternative to Calendly. This setup runs the prebuilt Cal.com web image against the shared **PostgreSQL** and **Valkey** services in this repository, so no bundled database or Redis container is started.

## Quick Start

```bash
# 1. Start the shared dependencies
cd ../postgresql && make up
cd ../valkey && make up

# 2. Create the Cal.com database (see Database Setup below)

# 3. Configure and start
cd ../cal.diy
make setup     # interactive: domain or localhost port
make secrets   # generates NEXTAUTH_SECRET, CALENDSO_ENCRYPTION_KEY, JWT_SECRET
make dns       # local hosts entry, for a domain that is not in public DNS
make up
```

First boot takes a few minutes: the container runs the Prisma migrations before serving traffic. Follow it with `make logs`.

## Configuration

Copy `.env.example` to `.env` (`make setup` does this) and configure:

The public URLs Cal.com serves (`NEXT_PUBLIC_WEBAPP_URL`, `NEXT_PUBLIC_WEBSITE_URL`, `NEXT_PUBLIC_API_V2_URL`, `NEXTAUTH_URL`) are **not** in `.env`. They are composed in `docker-compose.yml` from the access variables, so picking an access method is all there is to do:

### Domain Access
```bash
DOMAIN_PREFIX=calendar
DOMAIN=mac.boraaydin.com
HOST_PORT=
```
Serves `https://calendar.mac.boraaydin.com`, and the URLs follow from `https://${DOMAIN_PREFIX}.${DOMAIN}`.

### Localhost Access
```bash
DOMAIN_PREFIX=
DOMAIN=
HOST_PORT=3000
```
Serves `http://localhost:3000`. `docker-compose.ports.yml` is applied whenever `HOST_PORT` is set, and it overrides the same URLs with `http://localhost:${HOST_PORT}`.

> **Why this matters:** Cal.com bakes the app URL into its frontend and rewrites it at container start. A URL that disagrees with how you actually reach the app causes the classic "logged in, then redirected to localhost:3000" problem. Composing the URLs from the access variables removes the chance of that drift; `make check-config` reports the resulting URL before startup.

### Application Settings
- `NEXTAUTH_SECRET`: session signing key (`make secrets`)
- `CALENDSO_ENCRYPTION_KEY`: encrypts stored CalDAV/calendar credentials (`make secrets`)
- `JWT_SECRET`: API v2 token signing key (`make secrets`)
- `NEXT_PUBLIC_LICENSE_CONSENT`: must be `agree` to self-host, see the [Cal.com license](https://cal.com/license)
- `CALCOM_LICENSE_KEY`: only required for the commercial (EE) features
- `DOCKER_TAG` / `DOCKER_PLATFORM`: image version and architecture, which have to match. Cal.com publishes one image per architecture rather than a multi-arch manifest: the plain tags (`latest`, `v6.2.0`) are `linux/amd64` only and the `-arm` tags (`v6.2.0-arm`) are `linux/arm64` only, with no `latest-arm`, so arm64 hosts pin a version. Apple Silicon uses `v6.2.0-arm` + `linux/arm64`, Intel uses `latest` + `linux/amd64`. A mismatch fails the pull with `no matching manifest for linux/arm64/v8 in the manifest list entries`.
- `EMAIL_*`: SMTP settings — booking confirmations and invitations are not delivered until these are set

## Dependencies

### Required Infrastructure
1. **shared_network**: Docker network created by `make install` in the repository root
2. **[PostgreSQL](../postgresql)**: application database, reached at `postgres:5432`
3. **[Valkey](../valkey)**: Redis-compatible cache, reached at `valkey:6379`

### Optional Infrastructure
- **[Traefik](../traefik)**: domain-based access with SSL
- DNS configuration: `make dns` for local hosts entries

## Database Setup

Cal.com uses the shared PostgreSQL instance. Create its database once:

```bash
docker exec -it postgres psql -U admin -c "CREATE DATABASE calendso;"
```

Match `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB` in `.env` with the credentials in `../postgresql/.env`. Schema migrations run automatically on every container start.

## Redis / Valkey

The shared Valkey service replaces the Redis container from the upstream Cal.com compose file. `REDIS_URL` is assembled from `REDIS_HOST`, `REDIS_PORT` and `REDIS_PASSWORD`, so keep `REDIS_PASSWORD` in sync with `VALKEY_PASSWORD` in `../valkey/.env`.

## API v2 (optional)

Cal.com does not publish a prebuilt image for API v2, so it has to be built from source. It is kept out of the default stack in `docker-compose.api.yml`:

```bash
git clone --depth 1 https://github.com/calcom/cal.com.git source
make up-api
```

The API stays on the internal network only. The web container proxies it at `/api/v2` (`REWRITE_API_V2_PREFIX=true`), so it needs no domain or certificate of its own. `CALCOM_SOURCE_DIR` in `.env` points at the checkout, and `source/` is git-ignored. In port mode `make up-api` also applies `docker-compose.api.ports.yml`, which points the API's `WEB_APP_URL` at localhost.

## Usage

### Basic Commands
```bash
make setup        # Interactive setup (domain or port)
make secrets      # Generate missing secrets in .env
make check-config # Validate URLs and secrets
make up           # Start Cal.com
make up-api       # Start Cal.com together with API v2
make down         # Stop Cal.com
make restart      # Restart services
make logs         # View logs
make ps           # List containers
make clean        # Remove containers and volumes
make traefik-logs # View Traefik logs for this app
```

### DNS Configuration
```bash
make dns       # Auto-detect OS and add the domain to the hosts file
make check-dns # Verify the domain resolves
```

Hosts file locations: `/private/etc/hosts` (macOS), `/etc/hosts` (Linux), `C:\Windows\System32\drivers\etc\hosts` (Windows).

## Features

- **Event Types**: configurable meeting lengths, buffers and availability windows
- **Calendar Sync**: Google, Outlook, CalDAV and Apple Calendar integrations
- **Team Scheduling**: round-robin and collective booking
- **Workflows**: automated email and SMS reminders
- **Video Integrations**: Cal Video, Zoom, Google Meet and others
- **Embeds & API**: booking pages embeddable anywhere, plus a REST API

## Ports

- **3000**: Cal.com web interface (exposed only when `HOST_PORT` is set)
- **5555**: API v2, internal network only (optional)

## Volumes

None. All state lives in the shared PostgreSQL database, so `make clean` removes no user data.
