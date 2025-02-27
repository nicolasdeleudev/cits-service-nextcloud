#!/bin/bash
set -eu

echo "=== Maintenance post-installation de la base de données ==="

# Activation du mode maintenance
php /var/www/html/occ maintenance:mode --on

# Ajout des indices manquants
echo "Ajout des indices manquants..."
php /var/www/html/occ db:add-missing-indices

# Désactivation du mode maintenance
php /var/www/html/occ maintenance:mode --off

echo "=== Maintenance post-installation terminée ===" 