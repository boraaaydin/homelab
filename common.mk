# Common Makefile definitions and targets for homelab services
# Include this file in service-specific Makefiles

# Shell configuration (fix for Windows compatibility)
SHELL := /bin/sh
.SHELLFLAGS := -c

# Include interactive setup
-include $(dir $(lastword $(MAKEFILE_LIST)))setup-interactive.mk

# Docker commands
DOCKER := docker --context=default
DOCKER_COMPOSE := docker --context=default compose

# Colors for output (use with printf, not echo)
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m

# Common variables (can be overridden in service Makefiles)
ENV_FILE := .env
ENV_EXAMPLE_FILE := .env.example

# Common function to extract and validate domain variables
define get_domain_vars
	DOMAIN_PREFIX_VALUE=$$(grep '^DOMAIN_PREFIX' $(ENV_FILE) 2>/dev/null | cut -d '=' -f2 | tr -d ' "'"'"''); \
	DOMAIN_VALUE=$$(grep '^DOMAIN=' $(ENV_FILE) 2>/dev/null | head -1 | cut -d '=' -f2 | tr -d ' "'"'"'' || grep '^BASE_DOMAIN=' $(ENV_FILE) 2>/dev/null | head -1 | cut -d '=' -f2 | tr -d ' "'"'"'' || grep '^CUSTOMDOMAIN=' $(ENV_FILE) 2>/dev/null | head -1 | cut -d '=' -f2 | tr -d ' "'"'"''); \
	if [ -z "$${DOMAIN_PREFIX_VALUE}" ] || [ -z "$${DOMAIN_VALUE}" ]; then \
		printf "$(RED)DOMAIN_PREFIX or DOMAIN not set in .env file.$(NC)\n"; \
		exit 1; \
	fi; \
	FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"
endef

# Common phony targets
.PHONY: setup up run down restart logs ps clean dns check-dns check-env common-help

# Note: setup target is defined in setup-interactive.mk

# Check if .env file exists
check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		printf "$(RED)Error: .env file not found!$(NC)\n"; \
		echo ""; \
		printf "$(YELLOW)Please create .env file using one of these methods:$(NC)\n"; \
		echo ""; \
		printf "  $(GREEN)Option 1 - Interactive Setup (Recommended):$(NC)\n"; \
		echo "    make setup"; \
		echo ""; \
		printf "  $(GREEN)Option 2 - Manual Setup:$(NC)\n"; \
		echo "    cp $(ENV_EXAMPLE_FILE) $(ENV_FILE)"; \
		echo "    # Then edit $(ENV_FILE) with your configuration"; \
		echo ""; \
		exit 1; \
	fi

# Start containers (can be overridden for complex services)
up: check-env check-dns
	@docker context use default > /dev/null 2>&1 || true
	@echo "Starting $(APP_NAME)..."
	@# Source .env file to get HOST_PORT
	@if [ -f $(ENV_FILE) ]; then \
		set -a; . $(ENV_FILE); set +a; \
		if [ -n "$${HOST_PORT}" ]; then \
			printf "$(YELLOW)Port $${HOST_PORT} will be exposed$(NC)\n"; \
			$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { printf "$(RED)Error starting $(APP_NAME).$(NC)\n"; exit 1; }; \
		else \
			printf "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)\n"; \
			$(DOCKER_COMPOSE) up -d || { printf "$(RED)Error starting $(APP_NAME).$(NC)\n"; exit 1; }; \
		fi; \
	else \
		$(DOCKER_COMPOSE) up -d || { printf "$(RED)Error starting $(APP_NAME).$(NC)\n"; exit 1; }; \
	fi
	@printf "$(GREEN)$(APP_NAME) started successfully.$(NC)\n"

# Alias for up command
run: up

# Stop containers
down:
	@echo "Stopping $(APP_NAME)..."
	@$(DOCKER_COMPOSE) down
	@printf "$(GREEN)$(APP_NAME) stopped successfully.$(NC)\n"

# Restart containers
restart: down up

# View container logs
logs:
	@echo "Viewing $(APP_NAME) logs..."
	@$(DOCKER_COMPOSE) logs -f

# List containers
ps:
	@echo "Listing $(APP_NAME) containers..."
	@$(DOCKER_COMPOSE) ps

# Stop and remove containers and volumes
clean:
	@echo "Stopping and removing $(APP_NAME) containers and volumes..."
	@$(DOCKER_COMPOSE) down -v --remove-orphans
	@printf "$(GREEN)$(APP_NAME) cleaned successfully.$(NC)\n"

# Auto-detect OS and run appropriate DNS command (silent version for automation)
dns:
	@if [ ! -f $(ENV_FILE) ]; then \
		printf "$(RED).env file not found. Run 'make setup' first.$(NC)\n"; \
		exit 1; \
	fi
	@OS=$$(uname -s); \
	case "$$OS" in \
		Darwin*) \
			$(MAKE) dns-mac-auto; \
			;; \
		Linux*) \
			$(MAKE) dns-linux-auto; \
			;; \
		CYGWIN*|MINGW*|MSYS*) \
			$(MAKE) dns-windows-auto; \
			;; \
		*) \
			printf "$(RED)Unknown operating system: $$OS$(NC)\n"; \
			exit 1; \
			;; \
	esac

# DNS entries for macOS (automated version with auto sudo)
dns-mac-auto:
	@if [ ! -f $(ENV_FILE) ]; then \
		printf "$(RED).env file not found. Run 'make setup' first.$(NC)\n"; \
		exit 1; \
	fi; \
	$(get_domain_vars); \
	if grep -q "127.0.0.1.*$${FULL_DOMAIN}" /private/etc/hosts 2>/dev/null; then \
		printf "$(GREEN)✓ $${FULL_DOMAIN} already exists in /private/etc/hosts.$(NC)\n"; \
	else \
		printf "$(YELLOW)Adding $${FULL_DOMAIN} to /private/etc/hosts (requires sudo)...$(NC)\n"; \
		if echo "127.0.0.1       $${FULL_DOMAIN}" | sudo tee -a /private/etc/hosts > /dev/null; then \
			printf "$(GREEN)✓ Successfully added $${FULL_DOMAIN} to /private/etc/hosts$(NC)\n"; \
		else \
			printf "$(RED)✗ Failed to add DNS entry automatically.$(NC)\n"; \
			printf "$(YELLOW)Please run this command manually:$(NC)\n"; \
			printf "$(YELLOW)echo '127.0.0.1       $${FULL_DOMAIN}' | sudo tee -a /private/etc/hosts$(NC)\n"; \
			exit 1; \
		fi; \
	fi

# DNS entries for Linux (automated version with auto sudo)
dns-linux-auto:
	@if [ ! -f $(ENV_FILE) ]; then \
		printf "$(RED).env file not found. Run 'make setup' first.$(NC)\n"; \
		exit 1; \
	fi; \
	$(get_domain_vars); \
	if grep -q "127.0.0.1.*$${FULL_DOMAIN}" /etc/hosts 2>/dev/null; then \
		printf "$(GREEN)✓ $${FULL_DOMAIN} already exists in /etc/hosts.$(NC)\n"; \
	else \
		printf "$(YELLOW)Adding $${FULL_DOMAIN} to /etc/hosts (requires sudo)...$(NC)\n"; \
		if echo "127.0.0.1       $${FULL_DOMAIN}" | sudo tee -a /etc/hosts > /dev/null; then \
			printf "$(GREEN)✓ Successfully added $${FULL_DOMAIN} to /etc/hosts$(NC)\n"; \
		else \
			printf "$(RED)✗ Failed to add DNS entry automatically.$(NC)\n"; \
			printf "$(YELLOW)Please run this command manually:$(NC)\n"; \
			printf "$(YELLOW)echo '127.0.0.1       $${FULL_DOMAIN}' | sudo tee -a /etc/hosts$(NC)\n"; \
			exit 1; \
		fi; \
	fi

# DNS entries for Windows (automated version)
dns-windows-auto:
	@if [ ! -f $(ENV_FILE) ]; then \
		printf "$(RED).env file not found. Run 'make setup' first.$(NC)\n"; \
		exit 1; \
	fi; \
	$(get_domain_vars); \
	HOSTS_FILE="/c/Windows/System32/drivers/etc/hosts"; \
	if [ ! -f "$${HOSTS_FILE}" ]; then \
		HOSTS_FILE="/mnt/c/Windows/System32/drivers/etc/hosts"; \
	fi; \
	if [ ! -f "$${HOSTS_FILE}" ]; then \
		printf "$(RED)✗ Could not find Windows hosts file. Please add manually:$(NC)\n"; \
		printf "$(YELLOW)Add this line to C:\\Windows\\System32\\drivers\\etc\\hosts:$(NC)\n"; \
		echo "127.0.0.1       $${FULL_DOMAIN}"; \
		exit 1; \
	fi; \
	if grep -q "127.0.0.1.*$${FULL_DOMAIN}" "$${HOSTS_FILE}" 2>/dev/null; then \
		printf "$(GREEN)✓ $${FULL_DOMAIN} already exists in Windows hosts file.$(NC)\n"; \
	else \
		echo "Adding $${FULL_DOMAIN} to Windows hosts file (Administrator privileges required)..."; \
		echo "127.0.0.1       $${FULL_DOMAIN}" >> "$${HOSTS_FILE}" 2>/dev/null && \
		printf "$(GREEN)✓ $${FULL_DOMAIN} added to Windows hosts file.$(NC)\n" || \
		{ printf "$(RED)✗ Failed to add DNS entry. Run as Administrator or add manually:$(NC)\n"; \
		  printf "$(YELLOW)Add this line to C:\\Windows\\System32\\drivers\\etc\\hosts:$(NC)\n"; \
		  echo "127.0.0.1       $${FULL_DOMAIN}"; \
		  exit 1; }; \
	fi

# Check DNS record for the service
check-dns:
	@if [ ! -f $(ENV_FILE) ]; then \
		printf "$(RED).env file not found. Run 'make setup' first.$(NC)\n"; \
		exit 1; \
	fi; \
	DOMAIN_PREFIX_VALUE=$$(grep '^DOMAIN_PREFIX' $(ENV_FILE) 2>/dev/null | cut -d '=' -f2 | tr -d ' "'"'"''); \
	DOMAIN_VALUE=$$(grep '^DOMAIN=' $(ENV_FILE) 2>/dev/null | head -1 | cut -d '=' -f2 | tr -d ' "'"'"'' || grep '^BASE_DOMAIN=' $(ENV_FILE) 2>/dev/null | head -1 | cut -d '=' -f2 | tr -d ' "'"'"'' || grep '^CUSTOMDOMAIN=' $(ENV_FILE) 2>/dev/null | head -1 | cut -d '=' -f2 | tr -d ' "'"'"''); \
	HOST_PORT_VALUE=$$(grep '^HOST_PORT' $(ENV_FILE) 2>/dev/null | cut -d '=' -f2 | tr -d ' "'"'"''); \
	if [ -n "$${DOMAIN_PREFIX_VALUE}" ] && [ -n "$${DOMAIN_VALUE}" ]; then \
		FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
		printf "$(YELLOW)Checking DNS for $${FULL_DOMAIN}...$(NC)\n"; \
		HOSTS_FOUND=0; \
		if [ -f /etc/hosts ] && grep -q "127.0.0.1.*$${FULL_DOMAIN}" /etc/hosts 2>/dev/null; then \
			printf "$(GREEN)✓ Found in /etc/hosts: $${FULL_DOMAIN} -> 127.0.0.1$(NC)\n"; \
			HOSTS_FOUND=1; \
		elif [ -f /private/etc/hosts ] && grep -q "127.0.0.1.*$${FULL_DOMAIN}" /private/etc/hosts 2>/dev/null; then \
			printf "$(GREEN)✓ Found in /private/etc/hosts: $${FULL_DOMAIN} -> 127.0.0.1$(NC)\n"; \
			HOSTS_FOUND=1; \
		fi; \
		if [ "$$HOSTS_FOUND" -eq 0 ]; then \
			if command -v nslookup > /dev/null 2>&1; then \
				DNS_RESULT=$$(nslookup "$${FULL_DOMAIN}" 2>/dev/null | grep -E '^Address:|^Non-authoritative answer:' -A 1 | tail -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1); \
				if [ -n "$${DNS_RESULT}" ]; then \
					printf "$(GREEN)✓ DNS record found: $${FULL_DOMAIN} -> $${DNS_RESULT}$(NC)\n"; \
				else \
					printf "$(RED)✗ DNS record not found for $${FULL_DOMAIN}$(NC)\n"; \
					printf "$(YELLOW)Run 'make dns' to add DNS entry, then run 'make up' again.$(NC)\n"; \
					exit 1; \
				fi; \
			else \
				printf "$(YELLOW)⚠ nslookup not available, skipping DNS check$(NC)\n"; \
			fi; \
		fi; \
	elif [ -n "$${HOST_PORT_VALUE}" ]; then \
		printf "$(GREEN)✓ Service configured for localhost access on port $${HOST_PORT_VALUE}$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠ No domain or port configuration found$(NC)\n"; \
	fi

# Common help function (can be extended in service Makefiles)
define COMMON_HELP
Available commands:
  setup          - Interactive setup with domain/port selection
  up             - Start containers (requires .env file)
  run            - Alias for 'up' command
  down           - Stop containers
  restart        - Restart containers
  logs           - View container logs
  ps             - List containers
  clean          - Stop and remove containers and volumes
  dns            - Auto-detect OS and add domain to hosts file
  check-dns      - Check DNS record for the service domain
endef

# Common help target that can be used or extended
common-help:
	@echo "Available commands:"
	@echo "  setup          - Interactive setup with domain/port selection"
	@echo "  up             - Start containers (requires .env file)"
	@echo "  run            - Alias for 'up' command"
	@echo "  down           - Stop containers"
	@echo "  restart        - Restart containers"
	@echo "  logs           - View container logs"
	@echo "  ps             - List containers"
	@echo "  clean          - Stop and remove containers and volumes"
	@echo "  dns            - Auto-detect OS and add domain to hosts file"
	@echo "  check-dns      - Check DNS record for the service domain"