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

# CUSTOMDOMAIN değişkenini .env dosyasından al ve ~/.bashrc'de güncelle
if [ -n "$CUSTOMDOMAIN" ]; then
    # Eğer .bashrc'de CUSTOMDOMAIN zaten varsa, eski satırı kaldır
    sed -i '/export CUSTOMDOMAIN=/d' ~/.bashrc

    # Yeni CUSTOMDOMAIN değerini ekle
    echo "export CUSTOMDOMAIN=\"$CUSTOMDOMAIN\"" >> ~/.bashrc

    # Yeni ayarları yükle
    source ~/.bashrc

    echo "CUSTOMDOMAIN değişkeni güncellendi: $CUSTOMDOMAIN"
else
    echo "Hata: .env dosyasında CUSTOMDOMAIN değişkeni tanımlı değil!"
    exit 1
fi
