# Variables
APP_NAME := n8n

# Include common definitions and targets
include ../common.mk

# Include environment variables
ifneq (,$(wildcard .env.local))
    include .env.local
    export
endif

# Set full domain
FULL_DOMAIN := $(DOMAIN_PREFIX).$(DOMAIN)

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@$(info $(COMMON_HELP))
	@echo "  traefik-logs - View traefik logs"
	@echo "  help         - Show this help message"

# Override setup command (n8n expects .env.local to exist)
setup:
	@echo "Setting up $(APP_NAME)..."
	@test -f $(ENV_FILE) || \
	(test -f $(ENV_EXAMPLE_FILE) && \
	cp $(ENV_EXAMPLE_FILE) $(ENV_FILE) && \
	echo "$(GREEN).env.local file created from $(ENV_EXAMPLE_FILE)$(NC)" || \
	(echo "$(RED)Error: .env.local file not found and no .env.example available.$(NC)" && exit 1))
	@echo "$(GREEN)$(APP_NAME) setup completed successfully.$(NC)"

# Override up command to start traefik first
up: setup
	@echo "Starting $(APP_NAME)..."
	@cd ../traefik && $(DOCKER_COMPOSE) --env-file .env.local up -d || { echo "$(RED)Error starting traefik.$(NC)"; exit 1; }
	@# Source .env.local file to get HOST_PORT
	@if [ -f $(ENV_FILE) ]; then \
		set -a; . $(ENV_FILE); set +a; \
		if [ -n "$${HOST_PORT}" ]; then \
			echo "$(YELLOW)Port $${HOST_PORT} will be exposed$(NC)"; \
			$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
		else \
			echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
			$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
		fi; \
	else \
		$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"

# Override logs command to show specific container logs
logs:
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) logs -f n8n

# View traefik logs
traefik-logs:
	@cd ../traefik && $(DOCKER_COMPOSE) --env-file .env.local logs -f

.PHONY: traefik-logs 