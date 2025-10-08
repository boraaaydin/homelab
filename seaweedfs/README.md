# SeaweedFS

[SeaweedFS](https://github.com/seaweedfs/seaweedfs) is a fast, distributed storage system optimized for storing and serving billions of files efficiently. It provides object store, file system, and S3-compatible APIs.

## Features

- **High Performance**: O(1) disk seek time for fast file access
- **Scalable Architecture**: Distributed system with master and volume servers
- **S3 Compatible**: Full S3 API support for seamless integration
- **Multiple Access Methods**: Object store, FUSE mount, WebDAV, and more
- **Rack Awareness**: Intelligent data center and rack-aware replication
- **Cloud Tiering**: Support for erasure coding and cloud storage tiers

## Architecture

SeaweedFS consists of four main components:

1. **Master Server** (Port 9333): Manages volume allocation and cluster metadata
2. **Volume Server** (Port 8080): Stores actual file data
3. **Filer** (Port 8888): Provides file system abstraction and metadata management
4. **S3 Gateway** (Port 8333): S3-compatible API endpoint

## Prerequisites

- Docker and Docker Compose
- Traefik reverse proxy (for domain-based access)
- `shared_network` Docker network (created by `make install` in root)

## Setup

1. **Create environment file**:
   ```bash
   make setup
   ```

2. **Configure `.env`**:
   ```env
   # Docker Image
   DOCKER_TAG=latest

   # Domain Configuration
   DOMAIN_PREFIX=seaweedfs           # Master UI: seaweedfs.example.com
   VOLUME_DOMAIN_PREFIX=seaweedfs-volume
   FILER_DOMAIN_PREFIX=seaweedfs-filer
   S3_DOMAIN_PREFIX=seaweedfs-s3
   DOMAIN=example.com

   # S3 Credentials
   S3_ACCESS_KEY=your_access_key
   S3_SECRET_KEY=your_secret_key

   # Optional: Localhost port access
   # HOST_PORT_MASTER=9333
   # HOST_PORT_VOLUME=8080
   # HOST_PORT_FILER=8888
   # HOST_PORT_S3=8333
   ```

3. **Configure DNS** (if using domain access):
   ```bash
   make dns
   ```

4. **Start services**:
   ```bash
   make up
   ```

## Access

### Domain-based Access (with Traefik)

- **Master UI**: `https://seaweedfs.example.com`
- **Volume Server**: `https://seaweedfs-volume.example.com`
- **Filer**: `https://seaweedfs-filer.example.com`
- **S3 API**: `https://seaweedfs-s3.example.com`

### Localhost Access (with ports)

Uncomment `HOST_PORT_*` variables in `.env`, then:

- **Master UI**: `http://localhost:9333`
- **Volume Server**: `http://localhost:8080`
- **Filer**: `http://localhost:8888`
- **S3 API**: `http://localhost:8333`

## Usage

### S3 API

Use any S3-compatible client with your configured endpoint:

```bash
# Using AWS CLI
aws configure set aws_access_key_id your_access_key
aws configure set aws_secret_access_key your_secret_key
aws --endpoint-url https://seaweedfs-s3.example.com s3 ls

# Create a bucket
aws --endpoint-url https://seaweedfs-s3.example.com s3 mb s3://mybucket

# Upload a file
aws --endpoint-url https://seaweedfs-s3.example.com s3 cp file.txt s3://mybucket/
```

### Filer (File System)

Mount via FUSE or access via WebDAV:

```bash
# WebDAV access
curl https://seaweedfs-filer.example.com/path/to/file
```

## Available Commands

```bash
make setup          # Setup .env and S3 config
make up             # Start all SeaweedFS services
make down           # Stop all services
make restart        # Restart all services
make logs           # View container logs
make ps             # List running containers
make clean          # Remove containers and volumes
make dns            # Add domain to hosts file
make check-dns      # Check DNS configuration
make traefik-logs   # View Traefik logs for SeaweedFS
```

## Data Storage

- **Volume data**: `./seaweedfs_data/` (gitignored)
- **Filer metadata**: `./filer_data/` (gitignored)
- **S3 config**: `./config/s3.json` (auto-generated, gitignored)

## Dependencies

- **Traefik**: Required for HTTPS and domain-based routing
- **shared_network**: Docker network connecting all services

## Monitoring

- Master metrics: `http://seaweedfs-master:9327/metrics`
- Volume metrics: `http://seaweedfs-volume:9328/metrics`
- Filer metrics: `http://seaweedfs-filer:9329/metrics`

## Documentation

- [Official Documentation](https://github.com/seaweedfs/seaweedfs/wiki)
- [S3 API Guide](https://github.com/seaweedfs/seaweedfs/wiki/Amazon-S3-API)
- [Filer Documentation](https://github.com/seaweedfs/seaweedfs/wiki/Filer)

## Troubleshooting

### S3 Authentication Issues

Regenerate S3 config:
```bash
rm config/s3.json
make setup
```

### Volume Server Not Connecting

Check master logs:
```bash
docker logs seaweedfs-master
```

### Filer Issues

Ensure master is healthy:
```bash
docker ps
```
