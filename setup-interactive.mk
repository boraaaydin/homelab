# Interactive Setup Makefile
# This file overrides the default setup target with an interactive version

# Shell configuration
SHELL := /bin/bash
.SHELLFLAGS := -c

# Colors for output (only define if not already defined)
GREEN ?= \033[0;32m
YELLOW ?= \033[0;33m
RED ?= \033[0;31m
BLUE ?= \033[0;34m
NC ?= \033[0m

# Variables
ENV_FILE ?= .env.local
ENV_EXAMPLE_FILE ?= .env.example

# Override the default setup target with interactive setup
.PHONY: setup

setup:
	@if [ -f $(ENV_FILE) ]; then \
		printf "$(YELLOW).env.local file already exists.$(NC)\n"; \
		read -p "Do you want to reconfigure it? (y/N): " reconfigure; \
		if [ "$${reconfigure}" != "y" ] && [ "$${reconfigure}" != "Y" ]; then \
			printf "$(GREEN)Keeping existing .env.local file.$(NC)\n"; \
			exit 0; \
		fi; \
	fi; \
	\
	if [ ! -f $(ENV_EXAMPLE_FILE) ]; then \
		printf "$(RED)Error: $(ENV_EXAMPLE_FILE) not found!$(NC)\n"; \
		exit 1; \
	fi; \
	\
	printf "$(BLUE)========================================$(NC)\n"; \
	printf "$(BLUE)   Service Configuration Setup$(NC)\n"; \
	printf "$(BLUE)========================================$(NC)\n"; \
	echo ""; \
	echo "How do you want to access this service?"; \
	echo "  1) Domain (via Traefik with SSL)"; \
	echo "  2) Port (localhost:PORT)"; \
	echo ""; \
	printf "$(YELLOW)⚠️  Important for Domain access:$(NC)\n"; \
	printf "$(YELLOW)   - Your domain must be configured in Cloudflare$(NC)\n"; \
	printf "$(YELLOW)   - You need a Cloudflare API token with DNS edit permissions$(NC)\n"; \
	printf "$(YELLOW)   - Traefik must be properly configured$(NC)\n"; \
	echo ""; \
	read -p "Enter your choice (1 or 2): " access_choice; \
	\
	cp $(ENV_EXAMPLE_FILE) $(ENV_FILE); \
	\
	if [ "$${access_choice}" = "1" ]; then \
		echo ""; \
		printf "$(GREEN)Domain-based access selected$(NC)\n"; \
		echo ""; \
		DEFAULT_PREFIX=$$(basename "$$(pwd)"); \
		read -p "Enter your domain (e.g., example.com): " domain_value; \
		read -p "Enter subdomain prefix [$$DEFAULT_PREFIX]: " domain_prefix_value; \
		\
		if [ -z "$${domain_prefix_value}" ]; then \
			domain_prefix_value=$$DEFAULT_PREFIX; \
		fi; \
		\
		if [ -z "$${domain_value}" ] || [ -z "$${domain_prefix_value}" ]; then \
			printf "$(RED)Error: Domain and prefix cannot be empty!$(NC)\n"; \
			rm -f $(ENV_FILE); \
			exit 1; \
		fi; \
		\
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			sed -i '' "s|^DOMAIN=.*|DOMAIN=$${domain_value}|" $(ENV_FILE); \
			sed -i '' "s|^DOMAIN_PREFIX=.*|DOMAIN_PREFIX=$${domain_prefix_value}|" $(ENV_FILE); \
			sed -i '' "s|^HOST_PORT=.*|HOST_PORT=|" $(ENV_FILE); \
		else \
			sed -i "s|^DOMAIN=.*|DOMAIN=$${domain_value}|" $(ENV_FILE); \
			sed -i "s|^DOMAIN_PREFIX=.*|DOMAIN_PREFIX=$${domain_prefix_value}|" $(ENV_FILE); \
			sed -i "s|^HOST_PORT=.*|HOST_PORT=|" $(ENV_FILE); \
		fi; \
		\
		echo ""; \
		printf "$(BLUE)========================================$(NC)\n"; \
		printf "$(BLUE)   Traefik Configuration$(NC)\n"; \
		printf "$(BLUE)========================================$(NC)\n"; \
		echo ""; \
		printf "$(YELLOW)Configuring Traefik for domain: $${domain_value}$(NC)\n"; \
		echo ""; \
		\
		TRAEFIK_ENV_FILE="$$(dirname $$(pwd))/traefik/.env"; \
		TRAEFIK_ENV_EXAMPLE="$$(dirname $$(pwd))/traefik/.env.example"; \
		\
		if [ ! -f "$$TRAEFIK_ENV_EXAMPLE" ]; then \
			printf "$(RED)Warning: Traefik .env.example not found at $$TRAEFIK_ENV_EXAMPLE$(NC)\n"; \
			printf "$(YELLOW)Skipping Traefik configuration...$(NC)\n"; \
		else \
			existing_token=""; \
			existing_email=""; \
			\
			if [ -f "$$TRAEFIK_ENV_FILE" ]; then \
				existing_token=$$(grep "^CLOUDFLARE_DNS_API_TOKEN=" "$$TRAEFIK_ENV_FILE" | cut -d'=' -f2-); \
				existing_email=$$(grep "^CLOUDFLARE_API_EMAIL=" "$$TRAEFIK_ENV_FILE" | cut -d'=' -f2-); \
			fi; \
			\
			if [ -n "$$existing_token" ] && [ -n "$$existing_email" ]; then \
				printf "$(GREEN)✓ Cloudflare credentials already exist in Traefik configuration$(NC)\n"; \
				printf "$(YELLOW)Using existing credentials...$(NC)\n"; \
				cloudflare_token="$$existing_token"; \
				cloudflare_email="$$existing_email"; \
			else \
				read -p "Enter Cloudflare API Token: " cloudflare_token; \
				read -p "Enter Cloudflare API Email: " cloudflare_email; \
			fi; \
			\
			if [ -z "$${cloudflare_token}" ] || [ -z "$${cloudflare_email}" ]; then \
				printf "$(RED)Warning: Cloudflare credentials cannot be empty!$(NC)\n"; \
				printf "$(YELLOW)Traefik will not be configured. You'll need to configure it manually.$(NC)\n"; \
			else \
				if [ ! -f "$$TRAEFIK_ENV_FILE" ]; then \
					cp "$$TRAEFIK_ENV_EXAMPLE" "$$TRAEFIK_ENV_FILE"; \
				fi; \
				\
				if [[ "$$OSTYPE" == "darwin"* ]]; then \
					sed -i '' "s|^CUSTOMDOMAIN=.*|CUSTOMDOMAIN=$${domain_value}|" "$$TRAEFIK_ENV_FILE"; \
					sed -i '' "s|^CLOUDFLARE_DNS_API_TOKEN=.*|CLOUDFLARE_DNS_API_TOKEN=$${cloudflare_token}|" "$$TRAEFIK_ENV_FILE"; \
					sed -i '' "s|^CLOUDFLARE_API_EMAIL=.*|CLOUDFLARE_API_EMAIL=$${cloudflare_email}|" "$$TRAEFIK_ENV_FILE"; \
				else \
					sed -i "s|^CUSTOMDOMAIN=.*|CUSTOMDOMAIN=$${domain_value}|" "$$TRAEFIK_ENV_FILE"; \
					sed -i "s|^CLOUDFLARE_DNS_API_TOKEN=.*|CLOUDFLARE_DNS_API_TOKEN=$${cloudflare_token}|" "$$TRAEFIK_ENV_FILE"; \
					sed -i "s|^CLOUDFLARE_API_EMAIL=.*|CLOUDFLARE_API_EMAIL=$${cloudflare_email}|" "$$TRAEFIK_ENV_FILE"; \
				fi; \
				\
				printf "$(GREEN)✓ Traefik configured successfully!$(NC)\n"; \
			fi; \
		fi; \
		\
		echo ""; \
		printf "$(GREEN)✓ Configuration completed!$(NC)\n"; \
		printf "$(YELLOW)Service will be available at: https://$${domain_prefix_value}.$${domain_value}$(NC)\n"; \
		printf "$(YELLOW)Make sure to start Traefik first: cd traefik && make up$(NC)\n"; \
		\
	elif [ "$${access_choice}" = "2" ]; then \
		echo ""; \
		printf "$(GREEN)Port-based access selected$(NC)\n"; \
		echo ""; \
		printf "$(YELLOW)Please enter a port number between 3000 and 9000$(NC)\n"; \
		\
		while true; do \
			read -p "Enter port number: " user_port; \
			\
			if [ -z "$${user_port}" ]; then \
				printf "$(RED)Error: Port cannot be empty!$(NC)\n"; \
				continue; \
			fi; \
			\
			if ! [[ "$${user_port}" =~ ^[0-9]+$$ ]]; then \
				printf "$(RED)Error: Port must be a number!$(NC)\n"; \
				continue; \
			fi; \
			\
			if [ "$${user_port}" -lt 3000 ] || [ "$${user_port}" -gt 9000 ]; then \
				printf "$(RED)Error: Port must be between 3000 and 9000!$(NC)\n"; \
				continue; \
			fi; \
			\
			break; \
		done; \
		\
		SELECTED_PORT=$${user_port}; \
		\
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			sed -i '' "s|^HOST_PORT=.*|HOST_PORT=$${SELECTED_PORT}|" $(ENV_FILE); \
			sed -i '' "s|^DOMAIN=.*|DOMAIN=|" $(ENV_FILE); \
			sed -i '' "s|^DOMAIN_PREFIX=.*|DOMAIN_PREFIX=|" $(ENV_FILE); \
		else \
			sed -i "s|^HOST_PORT=.*|HOST_PORT=$${SELECTED_PORT}|" $(ENV_FILE); \
			sed -i "s|^DOMAIN=.*|DOMAIN=|" $(ENV_FILE); \
			sed -i "s|^DOMAIN_PREFIX=.*|DOMAIN_PREFIX=|" $(ENV_FILE); \
		fi; \
		\
		echo ""; \
		printf "$(GREEN)✓ Configuration completed!$(NC)\n"; \
		printf "$(YELLOW)Service will be available at: http://localhost:$${SELECTED_PORT}$(NC)\n"; \
		\
	else \
		printf "$(RED)Invalid choice! Please select 1 or 2.$(NC)\n"; \
		rm -f $(ENV_FILE); \
		exit 1; \
	fi; \
	\
	echo ""; \
	printf "$(GREEN).env.local file created successfully!$(NC)\n"; \
	printf "$(YELLOW)You can now run 'make up' to start the service.$(NC)\n"
