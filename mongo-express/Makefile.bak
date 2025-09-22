.PHONY: setup clean up down restart logs traefik-logs ps help dns-mac dns-linux dns-windows

include .env

APP_NAME=mongo-express
DOMAIN_PREFIX?=$(DOMAIN_PREFIX)
DOMAIN?=$(DOMAIN)
FULL_DOMAIN=$(DOMAIN_PREFIX).$(DOMAIN)
DOCKER_COMPOSE=docker --context=default compose

setup:
	@echo "Setting up $(APP_NAME)..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "Created .env file from .env.example"; \
		echo "Please edit .env file with your configuration"; \
	else \
		echo ".env file already exists"; \
	fi

clean:
	$(DOCKER_COMPOSE) down -v --remove-orphans

up:
	if [ -n "$(HOST_PORT)" ]; then \
		echo "\033[33mPort $(HOST_PORT) will be exposed\033[0m"; \
		$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ports.yml up -d || { echo "\033[31mError starting $(APP_NAME).\033[0m"; exit 1; }; \
	else \
		echo "\033[33mNo HOST_PORT defined, service will only be available through Traefik\033[0m"; \
		$(DOCKER_COMPOSE) up -d || { echo "\033[31mError starting $(APP_NAME).\033[0m"; exit 1; }; \
	fi

down:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) restart

logs:
	$(DOCKER_COMPOSE) logs -f --tail=100 $(APP_NAME)

traefik-logs:
	docker --context=default logs traefik 2>&1 | grep $(APP_NAME)

ps:
	$(DOCKER_COMPOSE) ps

help:
	@echo "Available commands:"
	@echo "  setup           Setup the app"
	@echo "  clean           Remove containers, networks, volumes"
	@echo "  up              Start the app"
	@echo "  down            Stop the app"
	@echo "  restart         Restart the app"
	@echo "  logs            Show app logs"
	@echo "  traefik-logs    Show traefik logs filtered by app name"
	@echo "  ps              Show container status"
	@echo "  dns-mac         Add DNS entry for macOS"
	@echo "  dns-linux       Add DNS entry for Linux"
	@echo "  dns-windows     Show DNS entry for Windows"

dns-mac:
	echo "127.0.0.1       $(FULL_DOMAIN)" | sudo tee -a /private/etc/hosts

dns-linux:
	echo "127.0.0.1       $(FULL_DOMAIN)" | sudo tee -a /etc/hosts

dns-windows:
	@echo "Add this line to C:\\Windows\\System32\\drivers\\etc\\hosts:"
	@echo "127.0.0.1       $(FULL_DOMAIN)"