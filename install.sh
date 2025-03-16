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

# Çevresel değişkeni .env dosyasından al ve ~/.bashrc dosyasına ekle
update_env_variable() {
    local var_name=$1

    # .env dosyasından değeri al
    local var_value=$(grep -E "^$var_name=" .env | cut -d '=' -f2-)

    if [ -n "$var_value" ]; then
        # Eğer .bashrc dosyasında değişken zaten varsa, eski satırı kaldır
        sed -i "/export $var_name=/d" ~/.bashrc

        # Yeni değişkeni .bashrc dosyasına ekle
        echo "export $var_name=\"$var_value\"" >> ~/.bashrc

        # Yeni ayarları yükle
        source ~/.bashrc

        echo "$var_name değişkeni güncellendi: $var_value"
    else
        echo "Hata: .env dosyasında $var_name değişkeni tanımlı değil!"
        exit 1
    fi
}

# Çevresel değişkenlerin güncellenmesi
update_env_variable "CUSTOMDOMAIN"
update_env_variable "CLOUDFLARE_API_EMAIL"
update_env_variable "CLOUDFLARE_DNS_API_TOKEN"
