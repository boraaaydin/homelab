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
	@echo "  make up      - Start n8n service"
	@echo "  make down    - Stop n8n service"

# Start service
up:
	@echo "Starting n8n..."
	@cd ../traefik && $(DOCKER_COMPOSE) up -d
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)n8n started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping n8n..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)n8n stopped successfully.$(NC)" 