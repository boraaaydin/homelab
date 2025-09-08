# Docker commands
DOCKER_COMPOSE := docker --context=default compose
DOCKER := docker --context=default

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

.PHONY: all up down help check-ready

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make up          - Start PostgreSQL service"
	@echo "  make down        - Stop PostgreSQL service"
	@echo "  make check-ready - Check if PostgreSQL is ready"

# Check if PostgreSQL is ready
check-ready:
	@echo "Checking PostgreSQL readiness..."
	@if $(DOCKER) exec $$($(DOCKER) ps -q -f name=postgres) pg_isready 2>/dev/null; then \
		echo "$(GREEN)PostgreSQL is ready!$(NC)"; \
	else \
		echo "$(RED)PostgreSQL is not ready.$(NC)"; \
		exit 1; \
	fi

# Start service
up:
	@echo "Starting PostgreSQL..."
	@cd ../traefik && $(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting traefik.$(NC)"; exit 1; }
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting PostgreSQL.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting PostgreSQL.$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)PostgreSQL started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping PostgreSQL..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)PostgreSQL stopped successfully.$(NC)" 