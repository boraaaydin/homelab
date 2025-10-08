# Ceph

Ceph is a unified, distributed storage system designed for excellent performance, reliability, and scalability. This deployment uses the **ceph/daemon** demo container which provides a complete all-in-one Ceph cluster with monitor (MON), manager (MGR), object storage daemon (OSD), and RADOS Gateway (RGW) for S3-compatible object storage.

## Features

- **All-in-One Demo**: Complete Ceph cluster in a single container
- **S3 Compatible API**: Access storage via S3-compatible RADOS Gateway
- **Web Dashboard**: Manage and monitor your cluster via Ceph Dashboard
- **Automatic Setup**: Pre-configured demo user and bucket
- **Easy Development**: Perfect for testing and development

## Prerequisites

- Docker and Docker Compose installed
- Traefik configured (for domain-based access)
- Shared Docker network created (`make install` from repository root)

## Quick Start

1. **Setup environment**
   ```bash
   make setup
   ```

2. **Configure `.env` file**
   Edit the `.env` file with your settings:
   - Set `DOMAIN` to your domain name
   - Configure `DOMAIN_PREFIX` for the dashboard (default: `ceph`)
   - Configure `S3_DOMAIN_PREFIX` for S3 gateway (default: `ceph-s3`)
   - Set S3 credentials: `CEPH_DEMO_ACCESS_KEY` and `CEPH_DEMO_SECRET_KEY`
   - Optionally change the demo bucket name: `CEPH_DEMO_BUCKET`

3. **Add DNS entries** (if using domain access)
   ```bash
   make dns
   ```

4. **Start Ceph cluster**
   ```bash
   make up
   ```

5. **Access the services**
   - Dashboard: `https://ceph.your.domain.com` (or `https://localhost:8443` if HOST_PORT is set)
   - S3 Gateway: `https://ceph-s3.your.domain.com` (or `http://localhost:8000` if HOST_PORT is set)

## Configuration

### Environment Variables

Key environment variables in `.env`:

- `DOCKER_IMAGE`: Ceph daemon image (default: `ceph/daemon`)
- `DOCKER_TAG`: Ceph version tag (default: `latest-reef`)
- `MON_IP`: Monitor IP address (default: `0.0.0.0`)
- `CEPH_PUBLIC_NETWORK`: Public network CIDR (default: `0.0.0.0/0`)
- `CEPH_DEMO_UID`: Demo user ID (default: `ceph-demo`)
- `CEPH_DEMO_ACCESS_KEY`: S3 access key for demo user
- `CEPH_DEMO_SECRET_KEY`: S3 secret key for demo user
- `CEPH_DEMO_BUCKET`: Default bucket name (default: `demo-bucket`)
- `RGW_NAME`: RADOS Gateway instance name
- `DOMAIN_PREFIX`: Dashboard subdomain prefix
- `S3_DOMAIN_PREFIX`: S3 Gateway subdomain prefix
- `DOMAIN`: Your domain name

### Localhost Access

To enable direct access via localhost ports, set in `.env`:
```
HOST_PORT_DASHBOARD=8443
HOST_PORT_S3=8000
```

## Services and Ports

The Ceph demo container provides:

1. **Monitor (MON)**: Maintains cluster maps
2. **Manager (MGR)**: Provides dashboard and monitoring on port `8443`
3. **OSD**: Stores data
4. **RADOS Gateway (RGW)**: Provides S3-compatible API on port `8000`

## Usage

### Common Commands

```bash
# View logs
make logs

# Restart services
make restart

# Stop services
make down

# Clean all data (WARNING: deletes all stored data)
make clean

# View Traefik logs
make traefik-logs
```

### Accessing the Dashboard

The Ceph Dashboard provides a web-based management interface:

1. Access via configured domain (e.g., `https://ceph.your.domain.com`)
2. Check container logs for dashboard credentials:
   ```bash
   docker logs ceph-demo | grep -i dashboard
   ```
3. Typical default credentials are printed during startup

### Using the S3 Gateway

The RADOS Gateway (RGW) provides S3-compatible object storage:

**Endpoint**: `https://ceph-s3.your.domain.com` or `http://localhost:8000`

**Credentials**: As configured in `.env` file
- Access Key: `CEPH_DEMO_ACCESS_KEY`
- Secret Key: `CEPH_DEMO_SECRET_KEY`

**Example with AWS CLI**:
```bash
# Configure AWS CLI
aws configure set aws_access_key_id YOUR_ACCESS_KEY
aws configure set aws_secret_access_key YOUR_SECRET_KEY

# List buckets
aws --endpoint-url=http://localhost:8000 s3 ls

# Upload file
aws --endpoint-url=http://localhost:8000 s3 cp file.txt s3://demo-bucket/

# Download file
aws --endpoint-url=http://localhost:8000 s3 cp s3://demo-bucket/file.txt downloaded.txt
```

**Example with Python boto3**:
```python
import boto3

s3_client = boto3.client(
    's3',
    endpoint_url='http://localhost:8000',
    aws_access_key_id='YOUR_ACCESS_KEY',
    aws_secret_access_key='YOUR_SECRET_KEY'
)

# List buckets
response = s3_client.list_buckets()
print([bucket['Name'] for bucket in response['Buckets']])

# Upload file
s3_client.upload_file('file.txt', 'demo-bucket', 'file.txt')

# Download file
s3_client.download_file('demo-bucket', 'file.txt', 'downloaded.txt')
```

## Data Persistence

All Ceph data is stored in local directories:
- `ceph_data/`: Ceph data (OSDs, MON, MGR, etc.)
- `ceph_config/`: Ceph configuration files

**Note**: Both directories are excluded from git via `.gitignore`

## Important Notes

⚠️ **This is a demo/development container** - Not suitable for production use!

- All services run in a single container
- Data is stored on the filesystem (not on dedicated block devices)
- No replication or high availability
- Perfect for testing, development, and learning Ceph
- For production, deploy a proper multi-node Ceph cluster

## Dependencies

- **Traefik**: Required for HTTPS and domain-based routing
- **shared_network**: Docker network for service communication

## Security Notes

- The container runs with elevated privileges (required for Ceph operations)
- Dashboard uses self-signed SSL certificates by default
- Configure strong S3 credentials in `.env` file
- For production use, deploy a proper Ceph cluster with authentication

## Troubleshooting

### Container not starting
```bash
# Check container logs
docker logs ceph-demo

# Verify privileges
# The container requires privileged mode
```

### Dashboard not accessible
```bash
# Verify Traefik routing
make traefik-logs

# Check DNS resolution
make check-dns

# Check dashboard is running
docker exec ceph-demo ceph mgr services
```

### S3 Gateway not working
```bash
# Check RGW status
docker exec ceph-demo ceph -s

# Verify S3 credentials
docker exec ceph-demo radosgw-admin user info --uid=ceph-demo
```

### Getting Dashboard Credentials
```bash
# View dashboard credentials
docker logs ceph-demo 2>&1 | grep -A 5 "dashboard"
```

## Additional Resources

- [Official Ceph Documentation](https://docs.ceph.com/)
- [Ceph Container Guide](https://docs.ceph.com/en/latest/install/containers/)
- [ceph/daemon Docker Hub](https://hub.docker.com/r/ceph/daemon)
- [RADOS Gateway S3 API](https://docs.ceph.com/en/latest/radosgw/s3/)

## License

This configuration is part of the homelab project and follows the repository's license.
