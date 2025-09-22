# Colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RED    := $(shell tput -Txterm setaf 1)
NC     := $(shell tput -Txterm sgr0)

# Docker compose command
DOCKER_COMPOSE = docker --context=default compose

# Load environment variables
include .env
export

# Full domain construction
FULL_DOMAIN=$(DOMAIN_PREFIX).$(DOMAIN)

.PHONY: setup clean up down restart logs traefik-logs ps help dns-mac dns-linux dns-windows test-health

help:
	@echo "Available commands:"
	@echo "  setup        : Initial setup and validation"
	@echo "  up           : Start services"
	@echo "  down         : Stop services"
	@echo "  restart      : Restart services"
	@echo "  logs         : View logs"
	@echo "  traefik-logs : View Traefik logs for this service"
	@echo "  ps           : List containers"
	@echo "  clean        : Remove containers and volumes"
	@echo "  dns-mac      : Add DNS entry to macOS hosts file"
	@echo "  dns-linux    : Add DNS entry to Linux hosts file"
	@echo "  dns-windows  : Show instructions for Windows DNS entry"
	@echo "  test-health  : Test container health check"

setup:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(YELLOW)Created .env file from example. Please update the values.$(NC)"; \
	fi

up:
	@echo "$(GREEN)Starting PgAdmin...$(NC)"
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting PgAdmin.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting PgAdmin.$(NC)"; exit 1; }; \
	fi

down:
	@echo "$(GREEN)Stopping PgAdmin...$(NC)"
	@$(DOCKER_COMPOSE) down

restart: down up

logs:
	@$(DOCKER_COMPOSE) logs -f

traefik-logs:
	@docker --context=default logs -f traefik 2>&1 | grep "pgadmin"

ps:
	@$(DOCKER_COMPOSE) ps

clean: down
	@echo "$(GREEN)Removing PgAdmin volumes...$(NC)"
	@docker --context=default volume rm saytak_pgadmin || true

test-health:
	@echo "$(GREEN)Testing health check inside container...$(NC)"
	@docker --context=default exec pgadmin4_container curl -f http://localhost:80/misc/ping || echo "$(RED)Health check failed$(NC)"

dns-mac:
	@echo "$(GREEN)Adding DNS entry to macOS hosts file...$(NC)"
	@echo "127.0.0.1       $(FULL_DOMAIN)" | sudo tee -a /private/etc/hosts
	@echo "$(GREEN)DNS entry added. You may need to flush your DNS cache.$(NC)"

dns-linux:
	@echo "$(GREEN)Adding DNS entry to Linux hosts file...$(NC)"
	@echo "127.0.0.1       $(FULL_DOMAIN)" | sudo tee -a /etc/hosts
	@echo "$(GREEN)DNS entry added. You may need to flush your DNS cache.$(NC)"

dns-windows:
	@echo "$(YELLOW)Please add the following line to C:\Windows\System32\drivers\etc\hosts:$(NC)"
	@echo "127.0.0.1       $(FULL_DOMAIN)" 