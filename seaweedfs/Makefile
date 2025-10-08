# Makefile for SeaweedFS

# Variables
APP_NAME := seaweedfs

# Include common definitions and targets
include ../common.mk

# Default target
all: help

# Override setup to generate S3 config
setup:
	@test -f $(ENV_FILE) && echo "$(YELLOW).env file already exists.$(NC)" || \
	(echo "Creating .env file from $(ENV_EXAMPLE_FILE)..." && \
	cp $(ENV_EXAMPLE_FILE) $(ENV_FILE) && \
	echo "$(GREEN).env file created successfully. Please edit it with your configuration.$(NC)")
	@mkdir -p config
	@if [ ! -f config/s3.json ]; then \
		echo "Creating S3 configuration file..."; \
		echo '{"identities":[{"name":"default","credentials":[{"accessKey":"'$$(grep '^S3_ACCESS_KEY' $(ENV_FILE) 2>/dev/null | cut -d '=' -f2 | tr -d ' "'"'"' || echo "your_access_key_here")'","secretKey":"'$$(grep '^S3_SECRET_KEY' $(ENV_FILE) 2>/dev/null | cut -d '=' -f2 | tr -d ' "'"'"' || echo "your_secret_key_here")'"}],"actions":["Admin","Read","Write"]}]}' > config/s3.json; \
		echo "$(GREEN)S3 configuration created at config/s3.json$(NC)"; \
	else \
		echo "$(YELLOW)S3 configuration already exists at config/s3.json$(NC)"; \
	fi

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

.PHONY: all help traefik-logs setup
