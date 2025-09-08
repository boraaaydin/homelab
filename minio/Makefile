# Makefile for minio

# Variables
APP_NAME := minio
DOCKER_COMPOSE := docker --context=default compose
ENV_FILE := .env
ENV_EXAMPLE_FILE := .env.example

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

# Default target
all: help

# Help message
help:
	@echo "Usage: make [command]"
	@echo ""
	@echo "Available commands:"
	@echo "  setup          - Setup .env file from .env.example"
	@echo "  up             - Start $(APP_NAME) containers"
	@echo "  down           - Stop $(APP_NAME) containers"
	@echo "  restart        - Restart $(APP_NAME) containers"
	@echo "  logs           - View $(APP_NAME) container logs"
	@echo "  traefik-logs   - View Traefik logs for $(APP_NAME)"
	@echo "  ps             - List $(APP_NAME) containers"
	@echo "  clean          - Stop and remove $(APP_NAME) containers and volumes"
	@echo "  dns-mac        - Add $(APP_NAME) domain to macOS hosts file"
	@echo "  dns-linux      - Add $(APP_NAME) domain to Linux hosts file"
	@echo "  dns-windows    - Instructions to add $(APP_NAME) domain to Windows hosts file"
	@echo "  help           - Show this help message"

# Setup .env file
setup:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Creating .env file from $(ENV_EXAMPLE_FILE)..."; \
		cp $(ENV_EXAMPLE_FILE) $(ENV_FILE); \
		echo "$(GREEN).env file created successfully. Please edit it with your configuration.$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists.$(NC)"; \
	fi

# Start containers
up: setup
	@echo "Starting $(APP_NAME)..."
	@# Source .env file to get HOST_PORT
	@set -a; . $(ENV_FILE); set +a
	@if [ -n "$${HOST_PORT}" ]; then \
		echo "$(YELLOW)Port $${HOST_PORT} will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"

# Stop containers
down:
	@echo "Stopping $(APP_NAME)..."
	$(DOCKER_COMPOSE) down
	@echo "$(GREEN)$(APP_NAME) stopped successfully.$(NC)"

# Restart containers
restart: down up

# View container logs
logs:
	@echo "Viewing $(APP_NAME) logs..."
	$(DOCKER_COMPOSE) logs -f

# View Traefik logs for this app
traefik-logs:
	@echo "Viewing Traefik logs for $(APP_NAME)..."
	docker --context=default logs traefik --tail 100 -f 2>&1 | grep "`grep DOMAIN_PREFIX $(ENV_FILE) | cut -d '=' -f2`.`grep DOMAIN $(ENV_FILE) | cut -d '=' -f2`" || echo "No logs found for $(APP_NAME) in Traefik, or .env file not configured."


# List containers
ps:
	@echo "Listing $(APP_NAME) containers..."
	$(DOCKER_COMPOSE) ps

# Stop and remove containers and volumes
clean:
	@echo "Stopping and removing $(APP_NAME) containers and volumes..."
	$(DOCKER_COMPOSE) down -v --remove-orphans
	@echo "$(GREEN)$(APP_NAME) cleaned successfully.$(NC)"

# Add domain to macOS hosts file
dns-mac: setup
	@DOMAIN_PREFIX_VALUE=$$(grep DOMAIN_PREFIX $(ENV_FILE) | cut -d '=' -f2); \
	DOMAIN_VALUE=$$(grep DOMAIN $(ENV_FILE) | cut -d '=' -f2); \
	if [ -z "$${DOMAIN_PREFIX_VALUE}" ] || [ -z "$${DOMAIN_VALUE}" ]; then \
		echo "$(RED)DOMAIN_PREFIX or DOMAIN not set in .env file.$(NC)"; \
		exit 1; \
	fi; \
	FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
	echo "Adding $${FULL_DOMAIN} to /private/etc/hosts..."; \
	if grep -q "127.0.0.1       $${FULL_DOMAIN}" /private/etc/hosts; then \
		echo "$(YELLOW)$${FULL_DOMAIN} already exists in /private/etc/hosts.$(NC)"; \
	else \
		echo "127.0.0.1       $${FULL_DOMAIN}" | sudo tee -a /private/etc/hosts; \
		echo "$(GREEN)$${FULL_DOMAIN} added to /private/etc/hosts. You might need to flush DNS cache.$(NC)"; \
	fi

# Add domain to Linux hosts file
dns-linux: setup
	@DOMAIN_PREFIX_VALUE=$$(grep DOMAIN_PREFIX $(ENV_FILE) | cut -d '=' -f2); \
	DOMAIN_VALUE=$$(grep DOMAIN $(ENV_FILE) | cut -d '=' -f2); \
	if [ -z "$${DOMAIN_PREFIX_VALUE}" ] || [ -z "$${DOMAIN_VALUE}" ]; then \
		echo "$(RED)DOMAIN_PREFIX or DOMAIN not set in .env file.$(NC)"; \
		exit 1; \
	fi; \
	FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
	echo "Adding $${FULL_DOMAIN} to /etc/hosts..."; \
	if grep -q "127.0.0.1       $${FULL_DOMAIN}" /etc/hosts; then \
		echo "$(YELLOW)$${FULL_DOMAIN} already exists in /etc/hosts.$(NC)"; \
	else \
		sudo bash -c "echo '127.0.0.1       $${FULL_DOMAIN}' >> logs"; \
		echo "$(GREEN)$${FULL_DOMAIN} added to /etc/hosts. You might need to flush DNS cache.$(NC)"; \
	fi

# Instructions to add domain to Windows hosts file
dns-windows: setup
	@DOMAIN_PREFIX_VALUE=$$(grep DOMAIN_PREFIX $(ENV_FILE) | cut -d '=' -f2); \
	DOMAIN_VALUE=$$(grep DOMAIN $(ENV_FILE) | cut -d '=' -f2); \
	if [ -z "$${DOMAIN_PREFIX_VALUE}" ] || [ -z "$${DOMAIN_VALUE}" ]; then \
		echo "$(RED)DOMAIN_PREFIX or DOMAIN not set in .env file.$(NC)"; \
		exit 1; \
	fi; \
	FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
	echo "$(YELLOW)Please add the following line to C:\\Windows\\System32\\drivers\\etc\\hosts:$(NC)"; \
	echo "127.0.0.1       $${FULL_DOMAIN}"

.PHONY: all help setup up down restart logs traefik-logs ps clean dns-mac dns-linux dns-windows 