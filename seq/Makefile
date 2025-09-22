# Variables
APP_NAME := seq

# Include common definitions and targets
include ../common.mk

# Include environment variables from .env file (optional for seq-specific variables)
-include .env

# Get full domain for DNS entries
FULL_DOMAIN = seq.$(BASE_DOMAIN)

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@$(info $(COMMON_HELP))
	@echo "  help         - Show this help message"

# Override up command to show access URLs
up: setup
	@echo "Starting $(APP_NAME)..."
	@# Source .env file to get HOST_PORT
	@if [ -f $(ENV_FILE) ]; then \
		set -a; . $(ENV_FILE); set +a; \
		if [ -n "$${SEQ_HOST_PORT}" ]; then \
			echo "$(YELLOW)Port $${SEQ_HOST_PORT} will be exposed$(NC)"; \
			$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
			echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"; \
			echo "Access Seq at: http://localhost:$${SEQ_HOST_PORT} or https://seq.$${BASE_DOMAIN}"; \
		else \
			echo "$(YELLOW)No SEQ_HOST_PORT defined, service will only be available through Traefik$(NC)"; \
			$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
			echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"; \
			echo "Access Seq at: https://seq.$${BASE_DOMAIN}"; \
		fi; \
	else \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
		echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"; \
	fi

# Override clean command for seq-specific volume cleanup
clean:
	@echo "Stopping and removing $(APP_NAME) containers and volumes..."
	@$(DOCKER_COMPOSE) down -v --remove-orphans
	@docker --context=default volume rm seq_seq_data 2>/dev/null || true
	@echo "$(GREEN)$(APP_NAME) cleaned successfully.$(NC)"