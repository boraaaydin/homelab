# Detect OS
ifeq ($(OS),Windows_NT)
	DETECTED_OS := Windows
else
	DETECTED_OS := $(shell uname -s)
endif

# Docker commands
DOCKER := docker
DOCKER_COMPOSE := docker compose

# Network name
NETWORK_NAME := shared_network

# Colors for output
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m

.PHONY: all install network help

# Default target
all: help

# Help message
help:
	@echo "Available commands:"
	@echo "  make install    - Install and setup Docker network"
	@echo "  make network    - Create Docker network"

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
		if [ "$(DETECTED_OS)" = "Windows" ]; then \
			$(DOCKER) network create --driver bridge $(NETWORK_NAME) || \
			$(DOCKER) network create --driver overlay --attachable $(NETWORK_NAME); \
		else \
			$(DOCKER) network create --driver overlay --attachable $(NETWORK_NAME); \
		fi; \
		echo "$(GREEN)Network created successfully.$(NC)"; \
	else \
		echo "$(GREEN)Network already exists.$(NC)"; \
	fi

# Install dependencies
install: check-docker check-compose network
	@echo "$(GREEN)Installation completed.$(NC)" 