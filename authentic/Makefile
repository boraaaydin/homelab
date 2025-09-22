# Variables
APP_NAME := authentic

# Include common definitions and targets
include ../common.mk

# Include environment variables
include .env
export

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@$(info $(COMMON_HELP))
	@echo "  traefik-logs   - View Traefik logs"
	@echo "  help           - Show this help message"

# Override setup command to generate secrets
setup:
	@echo "Setting up $(APP_NAME)..."
	@if [ ! -f $(ENV_FILE) ]; then \
		if [ -f $(ENV_EXAMPLE_FILE) ]; then \
			cp $(ENV_EXAMPLE_FILE) $(ENV_FILE); \
			echo "PG_PASS=$$(openssl rand -base64 36 | tr -d '\n')" >> $(ENV_FILE); \
			echo "AUTHENTIK_SECRET_KEY=$$(openssl rand -base64 60 | tr -d '\n')" >> $(ENV_FILE); \
			echo "$(GREEN).env file created with generated secrets$(NC)"; \
		else \
			echo "$(RED)No .env.example file found$(NC)"; \
			exit 1; \
		fi; \
	else \
		echo "$(YELLOW).env file already exists$(NC)"; \
	fi
	@echo "$(GREEN)$(APP_NAME) setup completed. Please edit .env file with your configuration.$(NC)"

# Override up command to pull images first
up: setup
	@echo "Starting $(APP_NAME)..."
	@$(DOCKER_COMPOSE) pull
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"

# Override clean command for authentic-specific cleanup
clean:
	@echo "Stopping and removing $(APP_NAME) containers and volumes..."
	@$(DOCKER_COMPOSE) down -v --remove-orphans
	@rm -rf ./media ./certs ./custom-templates
	@echo "$(GREEN)$(APP_NAME) cleaned successfully.$(NC)"

# View Traefik logs
traefik-logs:
	@cd ../traefik && $(DOCKER_COMPOSE) logs -f

.PHONY: all help traefik-logs
