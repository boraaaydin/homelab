include .env
export

FULLDOMAIN = $(DOMAIN_PREFIX).$(DOMAIN)

.PHONY: help
help: ## Bu yardım mesajını gösterir
	@awk 'BEGIN {FS = ":.*##"; printf "\nKullanım:\n  make \033[36m<hedef>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: setup
setup: ## Gerekli dosyaları ve ayarları hazırlar
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "PG_PASS=$$(openssl rand -base64 36 | tr -d '\n')" >> .env; \
		echo "AUTHENTIK_SECRET_KEY=$$(openssl rand -base64 60 | tr -d '\n')" >> .env; \
	fi
	@echo "Setup tamamlandı. .env dosyasını düzenlemeyi unutmayın!"

.PHONY: up
up: ## Konteynerleri başlatır
	docker --context=default compose pull
	docker --context=default compose up -d

.PHONY: down
down: ## Konteynerleri durdurur
	docker --context=default compose down

.PHONY: restart
restart: down up ## Konteynerleri yeniden başlatır

.PHONY: logs
logs: ## Konteyner loglarını gösterir
	docker --context=default compose logs -f

.PHONY: traefik-logs
traefik-logs: ## Traefik loglarını gösterir
	docker --context=default compose logs -f traefik

.PHONY: ps
ps: ## Çalışan konteynerleri listeler
	docker --context=default compose ps

.PHONY: clean
clean: down ## Tüm konteynerleri ve volumeleri temizler
	docker --context=default compose down -v
	rm -rf ./media ./certs ./custom-templates

.PHONY: dns-mac
dns-mac: ## MacOS için DNS kaydı ekler
	@echo "127.0.0.1 $(FULLDOMAIN)" | sudo tee -a /private/etc/hosts

.PHONY: dns-linux
dns-linux: ## Linux için DNS kaydı ekler
	@echo "127.0.0.1 $(FULLDOMAIN)" | sudo tee -a /etc/hosts

.PHONY: dns-windows
dns-windows: ## Windows için DNS kaydı ekler
	@echo "Windows için DNS kaydını manuel olarak ekleyin:"
	@echo "C:\Windows\System32\drivers\etc\hosts dosyasına ekleyin:"
	@echo "127.0.0.1 $(FULLDOMAIN)" 