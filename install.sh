#!/bin/bash

# .env dosyasını oku (export edilmemiş değişkenleri de al)
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Swarm zaten başlatılmış mı kontrol et
if ! docker info | grep -q "Swarm: active"; then
    docker swarm init
else
    echo "Docker Swarm zaten başlatılmış."
fi

# Docker ağı zaten mevcut mu kontrol et
if ! docker network ls | grep -q "shared_network"; then
    docker network create --driver overlay --attachable shared_network
else
    echo "Docker network 'shared_network' zaten mevcut."
fi

update_env_variable() {
    local var_name=$1
    local var_value=$(grep -E "^$var_name=" .env | cut -d '=' -f2-)

    if [ -z "$var_value" ]; then
        echo "Hata: .env dosyasında $var_name değişkeni tanımlı değil!"
        exit 1
    fi

    # Zsh ve Bash için config dosyalarını ayarla
    local shell_configs=("$HOME/.bashrc" "$HOME/.zshrc")

    for shell_config in "${shell_configs[@]}"; do
        if [ -f "$shell_config" ]; then
            # Eğer değişken zaten varsa, eski satırı kaldır
            sed -i "/export $var_name=/d" "$shell_config"
            
            # Yeni değişkeni ekle
            echo "export $var_name=\"$var_value\"" >> "$shell_config"
        fi
    done

    # Mevcut shell'e uygun olan dosyayı yükle
    if [ -n "$ZSH_VERSION" ]; then
        source "$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        source "$HOME/.bashrc"
    fi

    echo "$var_name değişkeni güncellendi: $var_value"
}

# Çevresel değişkenleri güncelle
update_env_variable "CUSTOMDOMAIN"
update_env_variable "CLOUDFLARE_API_EMAIL"
update_env_variable "CLOUDFLARE_DNS_API_TOKEN"


mkdir -p traefik/data/etc
mkdir -p traefik/data/log
mkdir -p traefik/data/certs

