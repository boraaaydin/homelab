# Docker commands
DOCKER_COMPOSE := docker --context=default compose

# Colors for output
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m

# Include environment variables from .env file
include .env

# Get full domain for DNS entries
FULL_DOMAIN = seq.$(BASE_DOMAIN)

.PHONY: all up down help setup clean restart logs ps dns-mac dns-linux dns-windows

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make setup   - Initial setup for Seq"
	@echo "  make up      - Start Seq service"
	@echo "  make down    - Stop Seq service"
	@echo "  make restart - Restart Seq service"
	@echo "  make logs    - View Seq logs"
	@echo "  make ps      - Show running containers"
	@echo "  make clean   - Clean up Seq data"
	@echo "  make dns-mac     - Add DNS entry for Mac"
	@echo "  make dns-linux   - Add DNS entry for Linux"
	@echo "  make dns-windows - Add DNS entry for Windows"

# Initial setup
setup:
	@echo "Setting up Seq..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(GREEN)Created .env file from .env.example$(NC)"; \
		echo "$(RED)Please edit .env file with your configuration$(NC)"; \
	fi
	@echo "$(GREEN)Seq setup completed.$(NC)"

# Start service
up:
	@echo "Starting Seq..."
	@if [ -n "$(SEQ_HOST_PORT)" ]; then \
		echo "$(GREEN)Port $(SEQ_HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting Seq.$(NC)"; exit 1; }; \
		echo "$(GREEN)Seq started successfully.$(NC)"; \
		echo "Access Seq at: http://localhost:$(SEQ_HOST_PORT) or https://$(FULL_DOMAIN)"; \
	else \
		echo "$(GREEN)No SEQ_HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting Seq.$(NC)"; exit 1; }; \
		echo "$(GREEN)Seq started successfully.$(NC)"; \
		echo "Access Seq at: https://$(FULL_DOMAIN)"; \
	fi

# Stop service
down:
	@echo "Stopping Seq..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Seq stopped successfully.$(NC)"

# Restart service
restart: down up

# View logs
logs:
	@$(DOCKER_COMPOSE) logs -f

# Show running containers
ps:
	@$(DOCKER_COMPOSE) ps

# Clean up
clean: down
	@echo "Cleaning up Seq data..."
	@docker --context=default volume rm seq_seq_data 2>/dev/null || true
	@echo "$(GREEN)Cleanup completed.$(NC)"

# DNS entries for different operating systems
dns-mac:
	@echo "Adding DNS entry for Mac..."
	@echo "127.0.0.1 $(FULL_DOMAIN)" | sudo tee -a /private/etc/hosts
	@echo "$(GREEN)DNS entry added successfully.$(NC)"

dns-linux:
	@echo "Adding DNS entry for Linux..."
	@echo "127.0.0.1 $(FULL_DOMAIN)" | sudo tee -a /etc/hosts
	@echo "$(GREEN)DNS entry added successfully.$(NC)"

dns-windows:
	@echo "To add DNS entry in Windows, run the following command as administrator:"
	@echo "echo 127.0.0.1 $(FULL_DOMAIN) >> %WINDIR%\\System32\\drivers\\etc\\hosts"