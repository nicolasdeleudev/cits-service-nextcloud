#!/bin/bash
set -eu

echo "=== Maintenance post-mise à jour ==="

# Activation du mode maintenance
php /var/www/html/occ maintenance:mode --on

# Ajout des indices manquants
echo "Optimisation de la base de données..."
php /var/www/html/occ db:add-missing-indices

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

# Désactivation du mode maintenance
php /var/www/html/occ maintenance:mode --off

echo "=== Maintenance post-mise à jour terminée ===" 