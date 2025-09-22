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

.PHONY: all setup up down restart logs clean dns-mac dns-linux dns-windows help

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make setup       - Copy .env.example to .env (if not exists)"
	@echo "  make up          - Start Couchbase service"
	@echo "  make down        - Stop Couchbase service"
	@echo "  make restart     - Restart Couchbase service"
	@echo "  make logs        - Show Couchbase logs"
	@echo "  make clean       - Stop and remove Couchbase containers and volumes"
	@echo "  make dns-mac     - Add local DNS entries (macOS)"
	@echo "  make dns-linux   - Add local DNS entries (Linux)"
	@echo "  make dns-windows - Show DNS setup instructions (Windows)"

# Setup environment
setup:
	@if [ ! -f .env ]; then \
		echo "Creating .env from .env.example..."; \
		cp .env.example .env; \
		echo "$(GREEN).env file created. Please edit it with your configuration.$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists.$(NC)"; \
	fi

# Start service
up:
	@echo "Starting Couchbase..."
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting Couchbase.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, using default ports$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting Couchbase.$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)Couchbase started successfully.$(NC)"
	@echo "$(YELLOW)Admin Console: http://localhost:8091$(NC)"

# Stop service
down:
	@echo "Stopping Couchbase..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Couchbase stopped successfully.$(NC)"

# Restart service
restart: down up

# Show logs
logs:
	@$(DOCKER_COMPOSE) logs -f

# Clean containers and volumes
clean:
	@echo "Cleaning Couchbase containers and volumes..."
	@$(DOCKER_COMPOSE) down -v --remove-orphans
	@echo "$(GREEN)Couchbase cleaned successfully.$(NC)"

# DNS configuration for macOS
dns-mac:
	@if [ -n "$(DOMAIN_PREFIX)" ] && [ -n "$(DOMAIN)" ]; then \
		echo "Adding DNS entry for $(DOMAIN_PREFIX).$(DOMAIN)..."; \
		echo "127.0.0.1 $(DOMAIN_PREFIX).$(DOMAIN)" | sudo tee -a /private/etc/hosts; \
		echo "$(GREEN)DNS entry added.$(NC)"; \
	else \
		echo "$(RED)DOMAIN_PREFIX and DOMAIN must be set in .env$(NC)"; \
	fi

# DNS configuration for Linux
dns-linux:
	@if [ -n "$(DOMAIN_PREFIX)" ] && [ -n "$(DOMAIN)" ]; then \
		echo "Adding DNS entry for $(DOMAIN_PREFIX).$(DOMAIN)..."; \
		echo "127.0.0.1 $(DOMAIN_PREFIX).$(DOMAIN)" | sudo tee -a /etc/hosts; \
		echo "$(GREEN)DNS entry added.$(NC)"; \
	else \
		echo "$(RED)DOMAIN_PREFIX and DOMAIN must be set in .env$(NC)"; \
	fi

# DNS configuration for Windows
dns-windows:
	@if [ -n "$(DOMAIN_PREFIX)" ] && [ -n "$(DOMAIN)" ]; then \
		echo "$(YELLOW)Windows DNS Setup:$(NC)"; \
		echo "1. Open Command Prompt as Administrator"; \
		echo "2. Run: echo 127.0.0.1 $(DOMAIN_PREFIX).$(DOMAIN) >> C:\\Windows\\System32\\drivers\\etc\\hosts"; \
		echo "3. Or manually edit C:\\Windows\\System32\\drivers\\etc\\hosts"; \
		echo "4. Add line: 127.0.0.1 $(DOMAIN_PREFIX).$(DOMAIN)"; \
	else \
		echo "$(RED)DOMAIN_PREFIX and DOMAIN must be set in .env$(NC)"; \
	fi