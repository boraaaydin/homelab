# Variables
APP_NAME := postgres-pgadmin

# Default target
all: help

# Include common definitions and targets
include ../common.mk

# Help message
help: common-help
	@echo "  traefik-logs   - View Traefik logs"
	@echo "  help           - Show this help message"

# View Traefik logs
traefik-logs:
	@cd ../traefik && $(DOCKER_COMPOSE) logs -f

.PHONY: all help traefik-logs
