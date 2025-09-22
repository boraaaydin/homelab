.PHONY: setup clean up down restart logs traefik-logs ps help

help:
	@echo "Available commands:"
	@echo "  setup        - Initial setup (create .env file if not exists)"
	@echo "  up          - Start the containers"
	@echo "  down        - Stop the containers"
	@echo "  restart     - Restart the containers"
	@echo "  logs        - View container logs"
	@echo "  traefik-logs- View Traefik logs"
	@echo "  ps          - List containers"
	@echo "  clean       - Remove containers and volumes"

setup:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "Created .env file from .env.example"; \
		echo "Please update the .env file with your configuration"; \
	else \
		echo ".env file already exists"; \
	fi

up:
	docker --context=default compose up -d
	@if [ -f docker-compose.ports.yml ]; then \
		docker --context=default compose -f docker-compose.yml -f docker-compose.ports.yml up -d; \
	else \
		docker --context=default compose up -d; \
	fi

down:
	docker --context=default compose down

restart: down up

logs:
	docker --context=default compose logs -f

traefik-logs:
	docker --context=default compose logs -f traefik

ps:
	docker --context=default compose ps

clean:
	docker --context=default compose down -v --remove-orphans 