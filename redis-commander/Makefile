include .env
export

# Colors
YELLOW=\033[0;33m
RED=\033[0;31m
NC=\033[0m

# Docker compose command
DOCKER_COMPOSE=docker-compose

# Define full domain
FULL_DOMAIN=$(DOMAIN_PREFIX).$(DOMAIN)

.PHONY: help setup up up-with-ports down restart logs traefik-logs ps clean dns-mac dns-linux dns-windows test-healthcheck

setup: ## Setup the application
	@cp .env.example .env
	@echo "Setup complete. Please modify .env file with your configuration."

up: ## Start all services
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting Redis Commander.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting Redis Commander.$(NC)"; exit 1; }; \
	fi

up-with-ports: ## Start all services with ports exposed
	@$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d

down: ## Stop all services
	@$(DOCKER_COMPOSE) down

restart: ## Restart all services
	@$(DOCKER_COMPOSE) restart

logs: ## View logs
	@$(DOCKER_COMPOSE) logs -f

traefik-logs: ## View traefik logs for redis-commander
	@echo "$(YELLOW)Showing Traefik logs filtered for redis-commander...$(NC)"
	@docker logs traefik 2>&1 | grep -i "redis-commander\|$(DOMAIN_PREFIX).$(DOMAIN)"

ps: ## Check service status
	@$(DOCKER_COMPOSE) ps

clean: ## Remove all containers and volumes
	@$(DOCKER_COMPOSE) down -v
	@echo "All containers and volumes removed."

test-healthcheck: ## Test the healthcheck inside the container
	@$(DOCKER_COMPOSE) exec redis-commander curl -f http://localhost:8081/
	@echo "Healthcheck test completed."

dns-mac: ## Add DNS entry to /etc/hosts on macOS
	@grep -q "$(FULL_DOMAIN)" /private/etc/hosts || \
	sudo sh -c 'echo "127.0.0.1 $(FULL_DOMAIN)" >> /private/etc/hosts'
	@echo "DNS entry for $(FULL_DOMAIN) added to /private/etc/hosts"

dns-linux: ## Add DNS entry to /etc/hosts on Linux
	@grep -q "$(FULL_DOMAIN)" /etc/hosts || \
	sudo sh -c 'echo "127.0.0.1 $(FULL_DOMAIN)" >> /etc/hosts'
	@echo "DNS entry for $(FULL_DOMAIN) added to /etc/hosts"

dns-windows: ## Add DNS entry to Windows hosts file
	@echo "To add DNS entry on Windows, run the following command in PowerShell as Administrator:"
	@echo "Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value \"127.0.0.1 $(FULL_DOMAIN)\" -Force"

help: ## Display this help message
	@echo "Available commands:"
	@echo "  setup            Setup the application"
	@echo "  up               Start all services"
	@echo "  up-with-ports    Start all services with ports exposed"
	@echo "  down             Stop all services"
	@echo "  restart          Restart all services"
	@echo "  logs             View logs"
	@echo "  traefik-logs     View traefik logs"
	@echo "  ps               Check service status"
	@echo "  clean            Remove all containers and volumes"
	@echo "  test-healthcheck Test the healthcheck inside the container"
	@echo "  dns-mac          Add DNS entry to /etc/hosts on macOS"
	@echo "  dns-linux        Add DNS entry to /etc/hosts on Linux"
	@echo "  dns-windows      Add DNS entry to Windows hosts file"

.DEFAULT_GOAL := help 