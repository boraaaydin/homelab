include .env
export

FULLDOMAIN=$(DOMAIN_PREFIX).$(DOMAIN)

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Initial setup
	mkdir -p $(DATA_DIR)/cache $(DATA_DIR)/config

.PHONY: clean
clean: ## Remove all data
	rm -rf $(DATA_DIR)

.PHONY: up
up: ## Start containers
	docker --context=default compose up -d

.PHONY: down
down: ## Stop containers
	docker --context=default compose down

.PHONY: restart
restart: down up ## Restart containers

.PHONY: logs
logs: ## View container logs
	docker --context=default compose logs -f

.PHONY: traefik-logs
traefik-logs: ## View Traefik logs
	docker --context=default compose logs -f traefik

.PHONY: ps
ps: ## List containers
	docker --context=default compose ps

.PHONY: dns-mac
dns-mac: ## Add DNS record to /private/etc/hosts (MacOS)
	@echo "Adding DNS record for $(FULLDOMAIN)"
	@sudo sh -c 'echo "127.0.0.1 $(FULLDOMAIN)" >> /private/etc/hosts'

.PHONY: dns-linux
dns-linux: ## Add DNS record to /etc/hosts (Linux)
	@echo "Adding DNS record for $(FULLDOMAIN)"
	@sudo sh -c 'echo "127.0.0.1 $(FULLDOMAIN)" >> /etc/hosts'

.PHONY: dns-windows
dns-windows: ## Add DNS record to hosts file (Windows)
	@echo "Please run the following command in an Administrator PowerShell:"
	@echo "Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value '127.0.0.1 $(FULLDOMAIN)'" 