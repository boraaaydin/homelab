# Variables
APP_NAME := postgresql

# Default target
all: help

# Include common definitions and targets
include ../common.mk

# Include environment variables
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Help message
help: common-help
	@echo "  check-ready    - Check if PostgreSQL is ready"
	@echo "  help           - Show this help message"

# Check if PostgreSQL is ready
check-ready:
	@echo "Checking PostgreSQL readiness..."
	@if $(DOCKER) exec $$($(DOCKER) ps -q -f name=postgres) pg_isready 2>/dev/null; then \
		echo "$(GREEN)PostgreSQL is ready!$(NC)"; \
	else \
		echo "$(RED)PostgreSQL is not ready.$(NC)"; \
		exit 1; \
	fi

# Override up command to start traefik first
up: setup
	@echo "Starting $(APP_NAME)..."
	@cd ../traefik && $(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting traefik.$(NC)"; exit 1; }
	@# Source .env file to get HOST_PORT
	@if [ -f $(ENV_FILE) ]; then \
		set -a; . $(ENV_FILE); set +a; \
		if [ -n "$${HOST_PORT}" ]; then \
			echo "$(YELLOW)Port $${HOST_PORT} will be exposed$(NC)"; \
			$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
		else \
			echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
			$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
		fi; \
	else \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"

.PHONY: check-ready 