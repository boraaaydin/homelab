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
	@echo "  make up      - Start OpenWebUI service"
	@echo "  make down    - Stop OpenWebUI service"

# Start service
up:
	@echo "Starting OpenWebUI..."
	@cd ../traefik && $(DOCKER_COMPOSE) up -d
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)OpenWebUI started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping OpenWebUI..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)OpenWebUI stopped successfully.$(NC)" 