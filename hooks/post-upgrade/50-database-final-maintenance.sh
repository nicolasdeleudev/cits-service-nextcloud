#!/bin/bash
set -eu

echo "=== Maintenance finale post-installation des applications ==="

# Activation du mode maintenance
php /var/www/html/occ maintenance:mode --on

# Optimisation complète de la base de données après installation des applications
echo "Optimisation finale de la base de données..."
php /var/www/html/occ db:add-missing-columns
php /var/www/html/occ db:add-missing-indices
php /var/www/html/occ db:add-missing-primary-keys

# Réparation finale incluant les opérations coûteuses
echo "Réparation finale et migration des mimetypes..."
php /var/www/html/occ maintenance:repair --include-expensive

# Désactivation du mode maintenance
php /var/www/html/occ maintenance:mode --off

echo "=== Maintenance finale terminée ==="