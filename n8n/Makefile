# Docker commands
DOCKER_COMPOSE := docker --context=default compose

# Include environment variables
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Set full domain
FULL_DOMAIN := $(DOMAIN_PREFIX).$(DOMAIN)

# Colors for output
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[1;33m
NC := \033[0m

.PHONY: all up down help setup clean restart logs traefik-logs ps dns-mac dns-linux dns-windows

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make setup         - Initial setup for n8n"
	@echo "  make up           - Start n8n service"
	@echo "  make down         - Stop n8n service"
	@echo "  make restart      - Restart n8n service"
	@echo "  make logs         - View n8n logs"
	@echo "  make traefik-logs - View traefik logs"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Remove n8n containers and volumes"
	@echo "  make dns-mac      - Add DNS entry to /etc/hosts (MacOS)"
	@echo "  make dns-linux    - Add DNS entry to /etc/hosts (Linux)"
	@echo "  make dns-windows  - Add DNS entry to hosts file (Windows)"

# Setup service
setup:
	@echo "Setting up n8n..."
	@if [ ! -f .env ]; then \
		echo "$(RED)Error: .env file not found.$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Setup completed successfully.$(NC)"

# Start service
up:
	@echo "Starting n8n..."
	@cd ../traefik && $(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting traefik.$(NC)"; exit 1; }
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting n8n.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting n8n.$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)n8n started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping n8n..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)n8n stopped successfully.$(NC)"

# Restart service
restart: down up

# View logs
logs:
	@$(DOCKER_COMPOSE) logs -f n8n

# View traefik logs
traefik-logs:
	@cd ../traefik && $(DOCKER_COMPOSE) logs -f

# Show running containers
ps:
	@$(DOCKER_COMPOSE) ps

# Clean up
clean:
	@echo "Cleaning up n8n..."
	@$(DOCKER_COMPOSE) down -v
	@echo "$(GREEN)n8n cleaned successfully.$(NC)"

# DNS resolution for MacOS
dns-mac:
	@echo "Adding DNS entry to /private/etc/hosts..."
	@if grep -q "$(FULL_DOMAIN)" /private/etc/hosts; then \
		echo "$(YELLOW)DNS entry already exists.$(NC)"; \
	else \
		echo "127.0.0.1 $(FULL_DOMAIN)" | sudo tee -a /private/etc/hosts > /dev/null; \
		echo "$(GREEN)DNS entry added successfully.$(NC)"; \
	fi

# DNS resolution for Linux
dns-linux:
	@echo "Adding DNS entry to /etc/hosts..."
	@if grep -q "$(FULL_DOMAIN)" /etc/hosts; then \
		echo "$(YELLOW)DNS entry already exists.$(NC)"; \
	else \
		echo "127.0.0.1 $(FULL_DOMAIN)" | sudo tee -a /etc/hosts > /dev/null; \
		echo "$(GREEN)DNS entry added successfully.$(NC)"; \
	fi

# DNS resolution for Windows
dns-windows:
	@echo "To add DNS entry on Windows:"
	@echo "1. Open Notepad as Administrator"
	@echo "2. Open C:\Windows\System32\drivers\etc\hosts"
	@echo "3. Add the following line:"
	@echo "127.0.0.1 $(FULL_DOMAIN)"
	@echo "4. Save the file" 