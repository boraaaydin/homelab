# Detect OS
ifeq ($(OS),Windows_NT)
	DETECTED_OS := Windows
else
	DETECTED_OS := $(shell uname -s)
endif

# Docker commands
DOCKER := docker --context=default
DOCKER_COMPOSE := docker --context=default compose

# Network name
NETWORK_NAME := shared_network

# Colors for output
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m

.PHONY: all install network help stop clean

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make install    - Install and setup Docker network"
	@echo "  make network    - Create Docker network"
	@echo "  make clean     - Stop and remove all project containers"

# Check Docker installation
check-docker:
	@echo "Checking Docker installation..."
	@if ! command -v $(DOCKER) > /dev/null 2>&1; then \
		echo "$(RED)Docker is not installed. Please install Docker first.$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Docker check successful.$(NC)"

# Check Docker Compose installation
check-compose:
	@echo "Checking Docker Compose installation..."
	@if ! command -v $(DOCKER) compose > /dev/null 2>&1; then \
		echo "$(RED)Docker Compose is not installed.$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Docker Compose check successful.$(NC)"

# Create network
network: check-docker
	@echo "Checking Docker network..."
	@if ! $(DOCKER) network ls | grep -q "$(NETWORK_NAME)"; then \
		echo "Creating $(NETWORK_NAME)..."; \
		$(DOCKER) network create --driver bridge $(NETWORK_NAME); \
		echo "$(GREEN)Network created successfully.$(NC)"; \
	else \
		echo "$(GREEN)Network already exists.$(NC)"; \
	fi

# Install dependencies
install: check-docker check-compose network
	@echo "$(GREEN)Installation completed.$(NC)"

# Stop and remove all project containers
clean:
	@echo "Stopping and removing all project containers..."
	@for dir in */; do \
		if [ -f "$$dir/docker-compose.yml" ]; then \
			echo "Processing $$dir..."; \
			if [ -f "$$dir/.env.local" ]; then \
				cd "$$dir" && $(DOCKER_COMPOSE) --env-file .env.local down --remove-orphans; \
			else \
				cd "$$dir" && $(DOCKER_COMPOSE) down --remove-orphans; \
			fi; \
			cd ..; \
			echo "$(GREEN)Cleaned $$dir$(NC)"; \
		fi \
	done
	@echo "$(GREEN)All project containers have been stopped and removed.$(NC)" 