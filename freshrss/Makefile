# Docker commands
DOCKER_COMPOSE := docker compose
DOCKER := docker

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
	@echo "  make up      - Start FreshRSS service"
	@echo "  make down    - Stop FreshRSS service"

# Start service
up:
	@echo "Starting FreshRSS..."
	@cd ../traefik && $(DOCKER_COMPOSE) up -d
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)FreshRSS started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping FreshRSS..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)FreshRSS stopped successfully.$(NC)" 