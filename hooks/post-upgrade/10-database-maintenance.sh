#!/bin/bash
set -eu

echo "=== Maintenance post-mise à jour ==="

# Activation du mode maintenance
php /var/www/html/occ maintenance:mode --on

# Ajout des indices manquants
echo "Optimisation de la base de données..."
php /var/www/html/occ db:add-missing-indices

# Vérification de l'intégrité
echo "Vérification de l'intégrité..."
php /var/www/html/occ integrity:check-core
php /var/www/html/occ maintenance:repair

# Mise à jour des mimetypes
echo "Mise à jour des mimetypes..."
php /var/www/html/occ maintenance:mimetype:update-db
php /var/www/html/occ maintenance:mimetype:update-js

# Configuration du système
echo "Configuration du système..."
# Désactivation du mode débogage et niveau de log
php /var/www/html/occ config:system:set debug --value=false --type=boolean
php /var/www/html/occ config:system:set loglevel --value=2

# Configuration de la région téléphonique
php /var/www/html/occ config:system:set default_phone_region --value="FR"

# Configuration de la fenêtre de maintenance
php /var/www/html/occ config:system:set maintenance_window_start --value=1
php /var/www/html/occ config:system:set maintenance_window_end --value=4

# Migration et réparation des mimetypes
echo "Migration et réparation des mimetypes..."
php /var/www/html/occ maintenance:repair --include-expensive

# Désactivation du mode maintenance
php /var/www/html/occ maintenance:mode --off

echo "=== Maintenance post-mise à jour terminée ===" 