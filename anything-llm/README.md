# AnythingLLM

AnythingLLM is a full-stack application that allows you to turn any document, resource, or piece of content into context that any LLM can use as references during chatting. It's an all-in-one desktop application and Docker deployment that brings AI chat capabilities to your documents.

## Features

- Chat with your documents using any LLM
- Support for multiple document types
- Embeddings and vector database management
- Multi-user support
- Custom AI agent workflows

## Prerequisites

- Docker and Docker Compose installed
- `shared_network` Docker network (created by running `make install` from repository root)
- Traefik configured (if using domain-based access)

## Setup

1. **Run the interactive setup:**
   ```bash
   make setup
   ```
   Follow the prompts to choose between domain or port-based access:
   - **Domain access**: Service available via `https://anythingllm.yourdomain.com`
   - **Port access**: Service available via `http://localhost:3001`

2. **Start the service:**
   ```bash
   make up
   # or
   make run
   ```
   > **Note**: `make up` (or `make run`) will fail if `.env` file doesn't exist. You must run `make setup` first.

See [Setup Guide](../SETUP-INTERACTIVE.md) for detailed configuration options.

## Access

After starting the service, access it based on your configuration:
- **Domain access:** `https://anythingllm.yourdomain.com` (via Traefik with SSL)
- **Port access:** `http://localhost:3001` (if HOST_PORT is set)

## Available Commands

```bash
make          # Show all available commands
make setup    # Interactive setup - configure domain or port access
make up       # Start containers (includes DNS check)
make run      # Alias for 'make up'
make down     # Stop containers
make restart  # Restart containers
make logs     # View container logs
make ps       # List containers
make clean    # Stop and remove containers and volumes
make dns      # Manually add domain to hosts file
```

## Data Persistence

AnythingLLM stores data in the following mounted directories:
- `../server/storage` - Main storage directory
- `../collector/hotdir` - Hot directory for document collection
- `../collector/outputs` - Output directory

**Note:** These directories are listed in `.gitignore` and won't be committed to the repository.

## Dependencies

- **Traefik** (optional) - Required for domain-based access with SSL
- **shared_network** - Docker network for inter-service communication

## Troubleshooting

1. **Permission issues:** Adjust `UID` and `GID` in `.env` to match your user
2. **Port conflicts:** Change `HOST_PORT` in `.env` to an available port
3. **Domain not accessible:** Run `make dns` and ensure Traefik is running

## More Information

- [Official Documentation](https://docs.useanything.com/)
- [GitHub Repository](https://github.com/Mintplex-Labs/anything-llm)
- [Docker Hub](https://hub.docker.com/r/mintplexlabs/anythingllm)
