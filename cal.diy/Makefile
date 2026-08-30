# Variables
APP_NAME := cal.diy

# Default target
all: help

# Include common definitions and targets
include ../common.mk

# Validate URLs/secrets before the shared 'up' recipe runs
up: check-config

# Help message
help: common-help
	@echo "  secrets        - Generate the missing secrets in .env"
	@echo "  check-config   - Validate URL and secret configuration"
	@echo "  up-api         - Start Cal.com together with the API v2 service"
	@echo "  traefik-logs   - View Traefik logs"
	@echo "  help           - Show this help message"

# View Traefik logs
traefik-logs:
	@cd ../traefik && $(DOCKER_COMPOSE) logs -f | grep --line-buffered -i calcom

# Generate any secret left empty in .env
secrets: check-env
	@for key in NEXTAUTH_SECRET CALENDSO_ENCRYPTION_KEY JWT_SECRET; do \
		value=$$(grep "^$${key}=" $(ENV_FILE) | cut -d '=' -f2- | tr -d ' "'"'"''); \
		if [ -z "$${value}" ]; then \
			secret=$$(openssl rand -base64 32 | tr -d '\n/+=' | cut -c1-32); \
			if [ "$$(uname -s)" = "Darwin" ]; then \
				sed -i '' "s|^$${key}=.*|$${key}=$${secret}|" $(ENV_FILE); \
			else \
				sed -i "s|^$${key}=.*|$${key}=$${secret}|" $(ENV_FILE); \
			fi; \
			printf "$(GREEN)✓ Generated $${key}$(NC)\n"; \
		else \
			printf "$(GREEN)✓ $${key} already set$(NC)\n"; \
		fi; \
	done

# Validate that the secrets exist and report the URL Cal.com will be served at
check-config: check-env
	@set -a; . ./$(ENV_FILE); set +a; \
	MISSING=""; \
	for key in NEXTAUTH_SECRET CALENDSO_ENCRYPTION_KEY; do \
		eval "value=\$$$${key}"; \
		if [ -z "$${value}" ]; then MISSING="$${MISSING} $${key}"; fi; \
	done; \
	if [ -n "$${MISSING}" ]; then \
		printf "$(RED)✗ Missing secrets:$${MISSING}$(NC)\n"; \
		printf "$(YELLOW)Run 'make secrets' to generate them.$(NC)\n"; \
		exit 1; \
	fi; \
	if [ -z "$${DOCKER_TAG}" ] || [ -z "$${DOCKER_PLATFORM}" ]; then \
		printf "$(RED)✗ DOCKER_TAG and DOCKER_PLATFORM must both be set in $(ENV_FILE).$(NC)\n"; \
		exit 1; \
	fi; \
	case "$${DOCKER_PLATFORM}:$${DOCKER_TAG}" in \
		*arm64:*-arm|*amd64:*) \
			printf "$(GREEN)✓ Image $${DOCKER_IMAGE}:$${DOCKER_TAG} ($${DOCKER_PLATFORM})$(NC)\n" ;; \
		*arm64:*) \
			printf "$(RED)✗ DOCKER_PLATFORM=$${DOCKER_PLATFORM} needs an '-arm' DOCKER_TAG, got '$${DOCKER_TAG}'.$(NC)\n"; \
			printf "$(YELLOW)Cal.com has no 'latest-arm', pin a version such as v6.2.0-arm.$(NC)\n"; \
			exit 1 ;; \
		*:*-arm) \
			printf "$(RED)✗ DOCKER_TAG=$${DOCKER_TAG} is arm64 only, but DOCKER_PLATFORM=$${DOCKER_PLATFORM}.$(NC)\n"; \
			exit 1 ;; \
	esac; \
	if [ -n "$${DOMAIN_PREFIX}" ] && [ -n "$${DOMAIN}" ]; then \
		printf "$(GREEN)✓ Cal.com will be served at https://$${DOMAIN_PREFIX}.$${DOMAIN}$(NC)\n"; \
	elif [ -n "$${HOST_PORT}" ]; then \
		printf "$(GREEN)✓ Cal.com will be served at http://localhost:$${HOST_PORT}$(NC)\n"; \
	else \
		printf "$(RED)✗ Neither DOMAIN/DOMAIN_PREFIX nor HOST_PORT is set in $(ENV_FILE).$(NC)\n"; \
		printf "$(YELLOW)Run 'make setup' to pick an access method.$(NC)\n"; \
		exit 1; \
	fi

# Start Cal.com with the optional API v2 service (built from the Cal.com source)
up-api: use-default-context check-env check-config check-dns
	@set -a; . ./$(ENV_FILE); set +a; \
	if [ ! -d "$${CALCOM_SOURCE_DIR}" ]; then \
		printf "$(RED)✗ CALCOM_SOURCE_DIR ($${CALCOM_SOURCE_DIR}) not found.$(NC)\n"; \
		printf "$(YELLOW)Cal.com does not publish an API v2 image, clone the source first:$(NC)\n"; \
		printf "$(YELLOW)  git clone --depth 1 https://github.com/calcom/cal.com.git $${CALCOM_SOURCE_DIR}$(NC)\n"; \
		exit 1; \
	fi; \
	echo "Starting $(APP_NAME) with API v2..."; \
	if [ -n "$${HOST_PORT}" ]; then \
		printf "$(YELLOW)Port $${HOST_PORT} will be exposed$(NC)\n"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.api.yml -f docker-compose.ports.yml -f docker-compose.api.ports.yml up -d || { printf "$(RED)Error starting $(APP_NAME).$(NC)\n"; exit 1; }; \
	else \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.api.yml up -d || { printf "$(RED)Error starting $(APP_NAME).$(NC)\n"; exit 1; }; \
	fi; \
	printf "$(GREEN)$(APP_NAME) started successfully.$(NC)\n"

.PHONY: all help traefik-logs secrets check-config up-api
