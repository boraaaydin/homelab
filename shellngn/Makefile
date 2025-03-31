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
	@echo "  make up      - Start Shellngn service"
	@echo "  make down    - Stop Shellngn service"

# Start service
up:
	@echo "Starting Shellngn..."
	@cd ../traefik && $(DOCKER_COMPOSE) up -d
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Shellngn started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping Shellngn..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Shellngn stopped successfully.$(NC)" 