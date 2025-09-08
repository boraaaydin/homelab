.PHONY: up down restart logs ps clean setup help

# Include environment variables from .env file
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Docker Compose commands
DC = docker --context=default compose

# Default target
.DEFAULT_GOAL := help

setup: ## Initial project setup
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "⚙️ .env file created. Please update the values."; \
	fi

up: ## Start containers (with optional port exposure)
	@echo "🚀 Starting containers..."
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "📢 Port $(HOST_PORT) will be exposed"; \
		$(DC) -f docker-compose.yml -f docker-compose.ports.yml up -d; \
	else \
		echo "🔒 No HOST_PORT defined, service will only be available through Traefik"; \
		$(DC) up -d; \
	fi

down: ## Stop and remove containers
	@echo "🛑 Stopping containers..."
	@$(DC) down

restart: down up ## Restart containers

logs: ## Show container logs
	@$(DC) logs -f

traefik-logs: ## Show Traefik logs filtered for miniflux
	@echo "🔍 Showing Traefik logs for miniflux..."
	@docker --context=default logs traefik 2>&1 | grep -i miniflux

ps: ## List running containers
	@$(DC) ps

clean: down ## Remove all containers and volumes
	@echo "🧹 Cleaning up..."
	@$(DC) down -v

help: ## Show this help message
	@echo "🔍 Available commands:"
	@awk '/^[a-zA-Z_-]+:.*##/{printf "\033[36m%-20s\033[0m %s\n", substr($$1,1,length($$1)-1), substr($$0,index($$0,"##")+3)}' $(MAKEFILE_LIST) 