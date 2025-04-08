# Docker commands
DOCKER_COMPOSE := docker compose

# Colors for output
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m

# Include environment variables from .env file
include .env

# Get full domain for DNS entries
FULL_DOMAIN = traefik-dashboard.$(CUSTOMDOMAIN)

.PHONY: all up down help setup clean restart logs ps dns-mac dns-linux dns-windows

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make setup   - Initial setup for Traefik"
	@echo "  make up      - Start Traefik service"
	@echo "  make down    - Stop Traefik service"
	@echo "  make restart - Restart Traefik service"
	@echo "  make logs    - View Traefik logs"
	@echo "  make ps      - Show running containers"
	@echo "  make clean   - Clean up Traefik data"
	@echo "  make dns-mac     - Add DNS entry for Mac"
	@echo "  make dns-linux   - Add DNS entry for Linux"
	@echo "  make dns-windows - Add DNS entry for Windows"

# Initial setup
setup:
	@echo "Setting up Traefik..."
	@mkdir -p ./data/log
	@mkdir -p ./data/certs
	@echo "$(GREEN)Traefik setup completed.$(NC)"

# Start service
up:
	@echo "Starting Traefik..."
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Traefik started successfully.$(NC)"

# Stop service
down:
	@echo "Stopping Traefik..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Traefik stopped successfully.$(NC)"

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
	@echo "Cleaning up Traefik data..."
	@rm -rf ./data/*
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
	@echo "echo 127.0.0.1 $(FULL_DOMAIN) >> %WINDIR%\System32\drivers\etc\hosts" 