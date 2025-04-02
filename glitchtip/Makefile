.PHONY: setup clean up down restart logs traefik-logs ps clean help

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