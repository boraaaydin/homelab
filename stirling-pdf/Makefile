# Variables
APP_NAME := stirling-pdf

# Include common definitions and targets
include ../common.mk

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@$(info $(COMMON_HELP))
	@echo "  traefik-logs   - View Traefik logs"
	@echo "  help           - Show this help message"

# View Traefik logs
traefik-logs:
	@cd ../traefik && $(DOCKER_COMPOSE) logs -f

.PHONY: all help traefik-logs