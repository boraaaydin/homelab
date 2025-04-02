.PHONY: setup clean up down restart logs traefik-logs ps clean help dns-mac dns-linux dns-windows

# Variables
DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_FILE = docker-compose.yaml

help:
	@echo "Kullanılabilir komutlar:"
	@echo "  setup        - Gerekli dizinleri ve dosyaları oluşturur"
	@echo "  up           - Tüm servisleri başlatır"
	@echo "  down         - Tüm servisleri durdurur"
	@echo "  restart      - Tüm servisleri yeniden başlatır"
	@echo "  logs         - Tüm servislerin loglarını gösterir"
	@echo "  traefik-logs - Traefik loglarını gösterir"
	@echo "  ps           - Çalışan servisleri listeler"
	@echo "  clean        - Tüm container ve volumeleri temizler"
	@echo "  dns-mac      - Mac için DNS kaydı ekler"
	@echo "  dns-linux    - Linux için DNS kaydı ekler"
	@echo "  dns-windows  - Windows için DNS kaydı ekler"

setup:
	@if [ ! -f .env ]; then \
		echo "'.env' dosyası kopyalanıyor..."; \
		cp .env.example .env; \
	fi
	@echo "Shared network oluşturuluyor..."
	@docker network create shared_network 2>/dev/null || true

up:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d

down:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down

restart:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) restart

logs:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs -f

traefik-logs:
	docker logs -f traefik

ps:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps

clean:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v
	docker network rm shared_network 2>/dev/null || true

# DNS resolution commands
dns-mac:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '#' | xargs) && \
		FULL_DOMAIN="$${DOMAIN_PREFIX}.$${DOMAIN}" && \
		echo "Mac için DNS kaydı ekleniyor..." && \
		sudo sh -c "echo '127.0.0.1 $$FULL_DOMAIN' >> /private/etc/hosts" && \
		echo "DNS kaydı başarıyla eklendi: $$FULL_DOMAIN"; \
	else \
		echo ".env dosyası bulunamadı!"; \
		exit 1; \
	fi

dns-linux:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '#' | xargs) && \
		FULL_DOMAIN="$${DOMAIN_PREFIX}.$${DOMAIN}" && \
		echo "Linux için DNS kaydı ekleniyor..." && \
		sudo sh -c "echo '127.0.0.1 $$FULL_DOMAIN' >> /etc/hosts" && \
		echo "DNS kaydı başarıyla eklendi: $$FULL_DOMAIN"; \
	else \
		echo ".env dosyası bulunamadı!"; \
		exit 1; \
	fi

dns-windows:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '#' | xargs) && \
		FULL_DOMAIN="$${DOMAIN_PREFIX}.$${DOMAIN}" && \
		echo "Windows için DNS kaydı ekleniyor..." && \
		runas /user:Administrator "echo 127.0.0.1 $$FULL_DOMAIN >> %WINDIR%\\System32\\drivers\\etc\\hosts" && \
		echo "DNS kaydı başarıyla eklendi: $$FULL_DOMAIN"; \
	else \
		echo ".env dosyası bulunamadı!"; \
		exit 1; \
	fi 