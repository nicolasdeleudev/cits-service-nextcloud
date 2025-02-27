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

# Désactivation du mode maintenance
php /var/www/html/occ maintenance:mode --off

echo "=== Maintenance post-mise à jour terminée ===" 