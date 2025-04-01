.PHONY: up down restart logs ps clean setup help

# Include environment variables from .env file
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Docker Compose commands
DC = docker compose

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

ps: ## List running containers
	@$(DC) ps

clean: down ## Remove all containers and volumes
	@echo "🧹 Cleaning up..."
	@$(DC) down -v

pull: ## Pull latest images
	@echo "⬇️ Pulling latest images..."
	@$(DC) pull

help: ## Show this help message
	@echo "🔍 Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' 