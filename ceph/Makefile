# Makefile for Ceph

# Variables
APP_NAME := ceph

# Include common definitions and targets
include ../common.mk

# Default target
all: help

# Help message
help:
	@echo "Usage: make [command]"
	@echo ""
	@$(info $(COMMON_HELP))
	@echo "  traefik-logs   - View Traefik logs for $(APP_NAME)"
	@echo "  help           - Show this help message"

# View Traefik logs for this app
traefik-logs:
	@echo "Viewing Traefik logs for $(APP_NAME)..."
	@docker --context=default logs traefik --tail 100 -f 2>&1 | grep "`grep DOMAIN_PREFIX $(ENV_FILE) | cut -d '=' -f2`.`grep DOMAIN $(ENV_FILE) | cut -d '=' -f2`" || echo "No logs found for $(APP_NAME) in Traefik, or .env file not configured."

.PHONY: all help traefik-logs
