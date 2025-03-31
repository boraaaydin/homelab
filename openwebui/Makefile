# Docker commands
DOCKER_COMPOSE := docker compose

# Include environment variables
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Colors for output
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[1;33m
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
	@cd ../traefik && $(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting traefik.$(NC)"; exit 1; }
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting OpenWebUI.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting OpenWebUI.$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)OpenWebUI started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping OpenWebUI..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)OpenWebUI stopped successfully.$(NC)" 