# Stirling-PDF

A powerful locally hosted web-based PDF manipulation tool using Docker that allows you to perform various operations on PDF files, such as splitting, merging, converting, reorganizing, adding images, rotating, compressing, and more.

## Features

- Split, merge, and reorganize PDFs
- Convert to/from PDF (images, Office documents, etc.)
- OCR (Optical Character Recognition) support
- Add/extract images
- Rotate, compress, and add watermarks
- Sign PDFs
- Fill forms
- Remove pages
- And much more!

## Prerequisites

- Docker and Docker Compose installed
- Traefik reverse proxy configured (for domain-based access)
- Shared Docker network (`shared_network`)

## Setup

1. **Copy environment file**
   ```bash
   cp .env.example .env
   ```

2. **Configure environment variables in `.env`**
   ```bash
   # Domain Configuration
   DOMAIN_PREFIX=stirling-pdf
   DOMAIN=example.com

   # For localhost access, set HOST_PORT:
   # HOST_PORT=8080

   # Docker image version
   DOCKER_TAG=latest

   # Feature flags
   DISABLE_ADDITIONAL_FEATURES=false

   # Languages (comma-separated)
   LANGS=en_GB
   ```

3. **Configure DNS** (for domain-based access)
   ```bash
   make dns
   ```

4. **Start the service**
   ```bash
   make up
   ```

## Access

- **Domain-based**: https://stirling-pdf.example.com (replace with your configured domain)
- **Localhost**: http://localhost:8080 (if HOST_PORT is set)

## Available Commands

```bash
make setup      # Setup .env file from .env.example
make up         # Start containers
make down       # Stop containers
make restart    # Restart containers
make logs       # View container logs
make ps         # List containers
make clean      # Stop and remove containers and volumes
make dns        # Add domain to hosts file (auto-detects OS)
```

## Data Persistence

The following directories are created and mounted for data persistence:

- `./StirlingPDF/trainingData` - OCR training data for additional languages
- `./StirlingPDF/extraConfigs` - Additional configuration files
- `./StirlingPDF/customFiles` - Custom files and templates
- `./StirlingPDF/logs` - Application logs
- `./StirlingPDF/pipeline` - Pipeline configurations

## Language Support

Stirling-PDF supports multiple languages. Configure the `LANGS` environment variable with comma-separated language codes:

```bash
LANGS=en_GB,en_US,de_DE,fr_FR,es_ES
```

For additional OCR languages, place the tessdata files in `./StirlingPDF/trainingData/`.

## Dependencies

- **Traefik**: Reverse proxy for SSL/TLS termination (for domain-based access)
- **shared_network**: Docker network for inter-service communication

## Documentation

- Official Stirling-PDF Documentation: https://docs.stirlingpdf.com/
- GitHub Repository: https://github.com/Stirling-Tools/Stirling-PDF