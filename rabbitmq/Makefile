include .env

DOCKER_COMPOSE = docker --context=default compose
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m

# Şimdi değişkenlerimizi .env dosyasından alalım (varsa)
DOMAIN ?= example.com
DOMAIN_PREFIX ?= rabbitmq
FULL_DOMAIN = $(DOMAIN_PREFIX).$(DOMAIN)

.PHONY: setup clean up down restart logs traefik-logs ps help dns-mac dns-linux dns-windows

# Default target
.DEFAULT_GOAL := help

setup:
	@echo "$(GREEN)Setting up RabbitMQ...$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(YELLOW)Created .env file from example. Please edit it if needed.$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists.$(NC)"; \
	fi

up:
	@echo "$(GREEN)Starting RabbitMQ...$(NC)"
	@if [ -n "$(HOST_PORT)" ]; then \
		echo "$(YELLOW)Port $(HOST_PORT) will be exposed$(NC)"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "$(RED)Error starting RabbitMQ.$(NC)"; exit 1; }; \
	else \
		echo "$(YELLOW)No HOST_PORT defined, service will only be available through Traefik$(NC)"; \
		$(DOCKER_COMPOSE) up -d || { echo "$(RED)Error starting RabbitMQ.$(NC)"; exit 1; }; \
	fi

down:
	@echo "$(GREEN)Stopping RabbitMQ...$(NC)"
	@$(DOCKER_COMPOSE) down

restart: down up

logs:
	@echo "$(GREEN)Showing logs for RabbitMQ...$(NC)"
	@$(DOCKER_COMPOSE) logs -f

traefik-logs:
	@echo "$(GREEN)Showing Traefik logs for RabbitMQ...$(NC)"
	@cd ../traefik && $(DOCKER_COMPOSE) logs -f | grep -i "rabbitmq"

ps:
	@echo "$(GREEN)RabbitMQ container status:$(NC)"
	@$(DOCKER_COMPOSE) ps

clean:
	@echo "$(GREEN)Cleaning up RabbitMQ...$(NC)"
	@$(DOCKER_COMPOSE) down -v
	@echo "$(GREEN)Removed containers and volumes.$(NC)"

dns-mac:
	@echo "$(GREEN)Adding $(FULL_DOMAIN) to /etc/hosts...$(NC)"
	@grep -q "$(FULL_DOMAIN)" /etc/hosts || sudo sh -c 'echo "127.0.0.1 $(FULL_DOMAIN)" >> /private	/etc/hosts'
	@echo "$(GREEN)Done! $(FULL_DOMAIN) now points to 127.0.0.1$(NC)"

dns-linux:
	@echo "$(GREEN)Adding $(FULL_DOMAIN) to /etc/hosts...$(NC)"
	@grep -q "$(FULL_DOMAIN)" /etc/hosts || sudo sh -c 'echo "127.0.0.1 $(FULL_DOMAIN)" >> /etc/hosts'
	@echo "$(GREEN)Done! $(FULL_DOMAIN) now points to 127.0.0.1$(NC)"

dns-windows:
	@echo "$(YELLOW)To add $(FULL_DOMAIN) to your hosts file on Windows:$(NC)"
	@echo "1. Run Notepad as administrator"
	@echo "2. Open C:\\Windows\\System32\\drivers\\etc\\hosts"
	@echo "3. Add this line: 127.0.0.1 $(FULL_DOMAIN)"
	@echo "4. Save the file"

help:
	@echo "$(GREEN)RabbitMQ Makefile Commands:$(NC)"
	@echo "  setup         - Create .env file from example if it doesn't exist"
	@echo "  up            - Start RabbitMQ server"
	@echo "  down          - Stop RabbitMQ server"
	@echo "  restart       - Restart RabbitMQ server"
	@echo "  logs          - Show RabbitMQ logs"
	@echo "  traefik-logs  - Show Traefik logs filtered for RabbitMQ"
	@echo "  ps            - Show container status"
	@echo "  clean         - Remove containers and volumes"
	@echo "  dns-mac       - Add $(FULL_DOMAIN) to /etc/hosts on Mac"
	@echo "  dns-linux     - Add $(FULL_DOMAIN) to /etc/hosts on Linux"
	@echo "  dns-windows   - Instructions to add $(FULL_DOMAIN) to hosts file on Windows" 