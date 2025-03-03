#!/bin/bash

# Script pour configurer OPcache avec une valeur de mémoire plus élevée
# Ce script sera exécuté après l'installation de Nextcloud

echo "Configuring PHP OPcache..."

# Créer le répertoire de configuration PHP si nécessaire
mkdir -p /usr/local/etc/php/conf.d/

# Créer ou mettre à jour la configuration OPcache
cat > /usr/local/etc/php/conf.d/opcache-recommended.ini << 'EOF'
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.revalidate_freq=1
opcache.save_comments=1
EOF

echo "PHP OPcache configuration updated." 