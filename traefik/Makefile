# Docker commands
DOCKER_COMPOSE := docker compose

# Colors for output
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m

.PHONY: all up down help

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make up      - Start Traefik service"
	@echo "  make down    - Stop Traefik service"

# Start service
up:
	@echo "Starting Traefik..."
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Traefik started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping Traefik..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Traefik stopped successfully.$(NC)" 