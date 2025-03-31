# Docker commands
DOCKER_COMPOSE := docker compose
DOCKER := docker

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

.PHONY: all up down help check-traefik

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make up      - Start FreshRSS service"
	@echo "  make down    - Stop FreshRSS service"

# Check if Traefik is running
check-traefik:
	@echo "Checking Traefik status..."
	@cd ../traefik && $(DOCKER_COMPOSE) ps | grep -q "traefik" || { \
		echo "$(YELLOW)Starting Traefik...$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting Traefik.$(NC)"; exit 1; }; \
	}

# Start service
up: check-traefik
	@echo "Starting FreshRSS..."
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting FreshRSS.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting FreshRSS.$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)FreshRSS started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping FreshRSS..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)FreshRSS stopped successfully.$(NC)" 