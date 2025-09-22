# Variables
APP_NAME := traefik

# Include common definitions and targets
include ../common.mk

# Include environment variables from .env file (required for traefik)
include .env

# Get full domain for DNS entries
FULL_DOMAIN = traefik-dashboard.$(CUSTOMDOMAIN)

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@$(info $(COMMON_HELP))
	@echo "  help         - Show this help message"

# Override setup command for traefik-specific initialization
setup:
	@echo "Setting up $(APP_NAME)..."
	@mkdir -p ./data/log
	@mkdir -p ./data/certs
	@echo "$(GREEN)$(APP_NAME) setup completed.$(NC)"

# Override up command (traefik doesn't use ports.yml)
up: setup
	@echo "Starting $(APP_NAME)..."
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"

# Override clean command for traefik-specific cleanup
clean:
	@echo "Stopping and removing $(APP_NAME) containers..."
	@$(DOCKER_COMPOSE) down --remove-orphans
	@echo "Cleaning up $(APP_NAME) data..."
	@rm -rf ./data/*
	@echo "$(GREEN)$(APP_NAME) cleaned successfully.$(NC)" 