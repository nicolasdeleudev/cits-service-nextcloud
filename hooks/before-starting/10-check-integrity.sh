#!/bin/bash
set -eu

echo "=== Vérification de l'intégrité avant démarrage ==="

# Activation du mode maintenance
echo "🔒 Activation du mode maintenance..."
php /var/www/html/occ maintenance:mode --on

# Vérification et réparation de la base de données
echo "🔍 Vérification des indices de la base de données..."
php /var/www/html/occ db:add-missing-indices

echo "🔍 Vérification et conversion des champs de type binaire..."
php /var/www/html/occ db:convert-filecache-bigint

# Vérification et réparation de l'intégrité du core
echo "🔍 Vérification de l'intégrité du core..."
php /var/www/html/occ integrity:check-core

# Réparation générale
echo "🔧 Exécution des réparations générales..."
php /var/www/html/occ maintenance:repair

# Mise à jour des mimetypes
echo "🔄 Mise à jour des mimetypes..."
php /var/www/html/occ maintenance:mimetype:update-db
php /var/www/html/occ maintenance:mimetype:update-js

# Nettoyage du cache
echo "🧹 Nettoyage du cache..."
php /var/www/html/occ files:cleanup

# Désactivation du mode maintenance
echo "🔓 Désactivation du mode maintenance..."
php /var/www/html/occ maintenance:mode --off

echo "✅ Vérification de l'intégrité terminée" 