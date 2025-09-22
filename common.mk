# Common Makefile definitions and targets for homelab services
# Include this file in service-specific Makefiles

# Docker commands
DOCKER := docker --context=default
DOCKER_COMPOSE := docker --context=default compose

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

# Common variables (can be overridden in service Makefiles)
ENV_FILE := .env
ENV_EXAMPLE_FILE := .env.example

# Common phony targets
.PHONY: setup up down restart logs ps clean dns-auto check-dns

# Setup .env file from example
setup:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Creating .env file from $(ENV_EXAMPLE_FILE)..."; \
		cp $(ENV_EXAMPLE_FILE) $(ENV_FILE); \
		echo "$(GREEN).env file created successfully. Please edit it with your configuration.$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists.$(NC)"; \
	fi

# Start containers (can be overridden for complex services)
up: setup check-dns
	@echo "Starting $(APP_NAME)..."
	@# Source .env file to get HOST_PORT
	@if [ -f $(ENV_FILE) ]; then \
		set -a; . $(ENV_FILE); set +a; \
		if [ -n "$${HOST_PORT}" ]; then \
			echo "$(YELLOW)Port $${HOST_PORT} will be exposed$(NC)"; \
			$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
		else \
			echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
			$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
		fi; \
	else \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting $(APP_NAME).$(NC)"; exit 1; }; \
	fi
	@echo "$(GREEN)$(APP_NAME) started successfully.$(NC)"

# Stop containers
down:
	@echo "Stopping $(APP_NAME)..."
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)$(APP_NAME) stopped successfully.$(NC)"

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
	@echo "$(GREEN)$(APP_NAME) cleaned successfully.$(NC)"

# Auto-detect OS and run appropriate DNS command (silent version for automation)
dns-auto: setup
	@OS=$$(uname -s); \
	case "$$OS" in \
		Darwin*) \
			$(MAKE) dns-mac-auto; \
			;; \
		Linux*) \
			$(MAKE) dns-linux-auto; \
			;; \
		CYGWIN*|MINGW*|MSYS*) \
			$(MAKE) dns-windows; \
			;; \
		*) \
			echo "$(RED)Unknown operating system: $$OS$(NC)"; \
			echo "Please run one of: make dns-mac, make dns-linux, or make dns-windows"; \
			exit 1; \
			;; \
	esac

# DNS entries for macOS (automated version, no prompts)
dns-mac-auto: setup
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED).env file not found. Run 'make setup' first.$(NC)"; \
		exit 1; \
	fi; \
	DOMAIN_PREFIX_VALUE=$$(grep '^DOMAIN_PREFIX' $(ENV_FILE) | cut -d '=' -f2 | tr -d ' "'\'''); \
	DOMAIN_VALUE=$$(grep '^DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^BASE_DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^CUSTOMDOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	if [ -z "$${DOMAIN_PREFIX_VALUE}" ] || [ -z "$${DOMAIN_VALUE}" ]; then \
		echo "$(RED)DOMAIN_PREFIX or DOMAIN not set in .env file.$(NC)"; \
		exit 1; \
	fi; \
	FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
	if grep -q "127.0.0.1.*$${FULL_DOMAIN}" /private/etc/hosts; then \
		echo "$(GREEN)✓ $${FULL_DOMAIN} already exists in /private/etc/hosts.$(NC)"; \
	else \
		echo "Adding $${FULL_DOMAIN} to /private/etc/hosts (sudo required)..."; \
		if echo "127.0.0.1       $${FULL_DOMAIN}" | sudo tee -a /private/etc/hosts > /dev/null 2>&1; then \
			echo "$(GREEN)✓ $${FULL_DOMAIN} added to /private/etc/hosts.$(NC)"; \
		else \
			echo "$(RED)✗ Failed to add DNS entry. Please run 'make dns' manually.$(NC)"; \
			exit 1; \
		fi; \
	fi

# DNS entries for Linux (automated version, no prompts)
dns-linux-auto: setup
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED).env file not found. Run 'make setup' first.$(NC)"; \
		exit 1; \
	fi; \
	DOMAIN_PREFIX_VALUE=$$(grep '^DOMAIN_PREFIX' $(ENV_FILE) | cut -d '=' -f2 | tr -d ' "'\'''); \
	DOMAIN_VALUE=$$(grep '^DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^BASE_DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^CUSTOMDOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	if [ -z "$${DOMAIN_PREFIX_VALUE}" ] || [ -z "$${DOMAIN_VALUE}" ]; then \
		echo "$(RED)DOMAIN_PREFIX or DOMAIN not set in .env file.$(NC)"; \
		exit 1; \
	fi; \
	FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
	if grep -q "127.0.0.1.*$${FULL_DOMAIN}" /etc/hosts; then \
		echo "$(GREEN)✓ $${FULL_DOMAIN} already exists in /etc/hosts.$(NC)"; \
	else \
		echo "Adding $${FULL_DOMAIN} to /etc/hosts (sudo required)..."; \
		if sudo bash -c "echo '127.0.0.1       $${FULL_DOMAIN}' >> /etc/hosts" 2>&1; then \
			echo "$(GREEN)✓ $${FULL_DOMAIN} added to /etc/hosts.$(NC)"; \
		else \
			echo "$(RED)✗ Failed to add DNS entry. Please run 'make dns' manually.$(NC)"; \
			exit 1; \
		fi; \
	fi

dns-windows: setup
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED).env file not found. Run 'make setup' first.$(NC)"; \
		exit 1; \
	fi; \
	DOMAIN_PREFIX_VALUE=$$(grep '^DOMAIN_PREFIX' $(ENV_FILE) | cut -d '=' -f2 | tr -d ' "'\'''); \
	DOMAIN_VALUE=$$(grep '^DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^BASE_DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^CUSTOMDOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	if [ -z "$${DOMAIN_PREFIX_VALUE}" ] || [ -z "$${DOMAIN_VALUE}" ]; then \
		echo "$(RED)DOMAIN_PREFIX or DOMAIN not set in .env file.$(NC)"; \
		exit 1; \
	fi; \
	FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
	echo "$(YELLOW)Please add the following line to C:\\Windows\\System32\\drivers\\etc\\hosts:$(NC)"; \
	echo "127.0.0.1       $${FULL_DOMAIN}"

# Check DNS record for the service
check-dns: setup
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED).env file not found. Run 'make setup' first.$(NC)"; \
		exit 1; \
	fi; \
	DOMAIN_PREFIX_VALUE=$$(grep '^DOMAIN_PREFIX' $(ENV_FILE) | cut -d '=' -f2 | tr -d ' "'\'''); \
	DOMAIN_VALUE=$$(grep '^DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^BASE_DOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	if [ -z "$${DOMAIN_VALUE}" ]; then \
		DOMAIN_VALUE=$$(grep '^CUSTOMDOMAIN=' $(ENV_FILE) | head -1 | cut -d '=' -f2 | tr -d ' "'\'''); \
	fi; \
	HOST_PORT_VALUE=$$(grep '^HOST_PORT' $(ENV_FILE) | cut -d '=' -f2 | tr -d ' "'\'''); \
	if [ -n "$${DOMAIN_PREFIX_VALUE}" ] && [ -n "$${DOMAIN_VALUE}" ]; then \
		FULL_DOMAIN="$${DOMAIN_PREFIX_VALUE}.$${DOMAIN_VALUE}"; \
		echo "$(YELLOW)Checking DNS for $${FULL_DOMAIN}...$(NC)"; \
		HOSTS_FOUND=0; \
		if [ -f /etc/hosts ] && grep -q "127.0.0.1.*$${FULL_DOMAIN}" /etc/hosts 2>/dev/null; then \
			echo "$(GREEN)✓ Found in /etc/hosts: $${FULL_DOMAIN} -> 127.0.0.1$(NC)"; \
			HOSTS_FOUND=1; \
		elif [ -f /private/etc/hosts ] && grep -q "127.0.0.1.*$${FULL_DOMAIN}" /private/etc/hosts 2>/dev/null; then \
			echo "$(GREEN)✓ Found in /private/etc/hosts: $${FULL_DOMAIN} -> 127.0.0.1$(NC)"; \
			HOSTS_FOUND=1; \
		fi; \
		if [ "$$HOSTS_FOUND" -eq 0 ]; then \
			if command -v nslookup > /dev/null 2>&1; then \
				DNS_RESULT=$$(nslookup "$${FULL_DOMAIN}" 2>/dev/null | grep -E '^Address:|^Non-authoritative answer:' -A 1 | tail -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1); \
				if [ -n "$${DNS_RESULT}" ]; then \
					echo "$(GREEN)✓ DNS record found: $${FULL_DOMAIN} -> $${DNS_RESULT}$(NC)"; \
					if [ "$${DNS_RESULT}" = "127.0.0.1" ]; then \
						echo "$(GREEN)✓ Domain points to localhost (local development)$(NC)"; \
					else \
						echo "$(YELLOW)⚠ Domain points to external IP: $${DNS_RESULT}$(NC)"; \
					fi; \
				else \
					echo "$(RED)✗ DNS record not found for $${FULL_DOMAIN}$(NC)"; \
					echo "$(YELLOW)Adding DNS entry automatically...$(NC)"; \
					$(MAKE) dns-auto; \
				fi; \
			elif command -v dig > /dev/null 2>&1; then \
				DNS_RESULT=$$(dig +short "$${FULL_DOMAIN}" 2>/dev/null | head -1); \
				if [ -n "$${DNS_RESULT}" ]; then \
					echo "$(GREEN)✓ DNS record found: $${FULL_DOMAIN} -> $${DNS_RESULT}$(NC)"; \
					if [ "$${DNS_RESULT}" = "127.0.0.1" ]; then \
						echo "$(GREEN)✓ Domain points to localhost (local development)$(NC)"; \
					else \
						echo "$(YELLOW)⚠ Domain points to external IP: $${DNS_RESULT}$(NC)"; \
					fi; \
				else \
					echo "$(RED)✗ DNS record not found for $${FULL_DOMAIN}$(NC)"; \
					echo "$(YELLOW)Adding DNS entry automatically...$(NC)"; \
					$(MAKE) dns-auto; \
				fi; \
			else \
				echo "$(YELLOW)⚠ nslookup or dig not available, skipping DNS check$(NC)"; \
			fi; \
		fi; \
	elif [ -n "$${HOST_PORT_VALUE}" ]; then \
		echo "$(GREEN)✓ Service configured for localhost access on port $${HOST_PORT_VALUE}$(NC)"; \
	else \
		echo "$(YELLOW)⚠ No domain or port configuration found$(NC)"; \
	fi

# Common help function (can be extended in service Makefiles)
define COMMON_HELP
Available commands:
  setup          - Setup .env file from .env.example
  up             - Start containers (includes DNS check)
  down           - Stop containers
  restart        - Restart containers
  logs           - View container logs
  ps             - List containers
  clean          - Stop and remove containers and volumes
  dns            - Auto-detect OS and add domain to hosts file
  check-dns      - Check DNS record for the service domain
endef