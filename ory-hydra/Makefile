# Include .env file if it exists
-include .env

# Colors for echo
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
NC=\033[0m

# Docker compose command
DOCKER_COMPOSE=docker --context=default compose

# Get full domain from env variables
FULL_DOMAIN=${DOMAIN_PREFIX}.${DOMAIN}

.PHONY: setup clean up down restart logs traefik-logs ps help dns-mac dns-linux dns-windows

help:
	@echo "Available commands:"
	@echo "  setup         - Initial setup and configuration"
	@echo "  up            - Start all services"
	@echo "  down          - Stop all services"
	@echo "  restart       - Restart all services"
	@echo "  logs          - View logs of all services"
	@echo "  traefik-logs  - View Traefik logs filtered for this service"
	@echo "  ps            - List running services"
	@echo "  clean         - Remove all data and containers"
	@echo "  dns-mac       - Add DNS entry to /etc/hosts (MacOS)"
	@echo "  dns-linux     - Add DNS entry to /etc/hosts (Linux)"
	@echo "  dns-windows   - Add DNS entry to C:\Windows\System32\drivers\etc\hosts (Windows)"

setup:
	@echo "$(GREEN)Setting up Ory Hydra...$(NC)"
	@echo "$(YELLOW)Please create "hydra" database in postgres $(NC)"

up:
	@echo "$(GREEN)Starting Ory Hydra...$(NC)"
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting Ory Hydra.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting Ory Hydra.$(NC)"; exit 1; }; \
	fi

down:
	@echo "$(GREEN)Stopping Ory Hydra...$(NC)"
	@$(DOCKER_COMPOSE) down

restart: down up

logs:
	@$(DOCKER_COMPOSE) logs -f

traefik-logs:
	@docker --context=default logs -f traefik 2>&1 | grep "$(DOMAIN_PREFIX).$(DOMAIN)"

ps:
	@$(DOCKER_COMPOSE) ps

clean: down
	@echo "$(RED)Cleaning up Ory Hydra...$(NC)"
	@$(DOCKER_COMPOSE) down -v
	@rm -f .env

dns-mac dns-linux:
	@echo "$(GREEN)Adding DNS entry to /etc/hosts...$(NC)"
	@echo "127.0.0.1 ${DOMAIN_PREFIX}-admin.${DOMAIN}" | sudo tee -a /etc/hosts
	@echo "127.0.0.1 ${DOMAIN_PREFIX}-token.${DOMAIN}" | sudo tee -a /etc/hosts
	@echo "127.0.0.1 ${DOMAIN_PREFIX}.${DOMAIN}" | sudo tee -a /etc/hosts
	@echo "$(GREEN)DNS entry added successfully$(NC)"

dns-windows:
	@echo "$(YELLOW)Please run the following command in an Administrator PowerShell:$(NC)"
	@echo "Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value \"127.0.0.1 $(FULL_DOMAIN)\" -Force" 