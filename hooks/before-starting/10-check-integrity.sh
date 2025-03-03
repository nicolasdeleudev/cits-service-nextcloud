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

# Mise à jour des mimetypes (pour résoudre le problème d'intégrité avec mimetypelist.js)
echo "🔄 Mise à jour des mimetypes..."
php /var/www/html/occ maintenance:mimetype:update-db --repair-filecache
php /var/www/html/occ maintenance:mimetype:update-js
php /var/www/html/occ maintenance:theme:update

# Réparation générale
echo "🔧 Exécution des réparations générales..."
php /var/www/html/occ maintenance:repair

# Vérification de l'intégrité du core (sans l'option --repair qui n'existe pas)
echo "🔍 Vérification de l'intégrité du core..."
# Exécution de la commande sans faire échouer le script si elle échoue
php /var/www/html/occ integrity:check-core || {
    echo "⚠️ Des problèmes d'intégrité ont été détectés, mais nous continuons..."
}

# Nettoyage du cache (alternatives à files:cleanup)
echo "🧹 Nettoyage du cache et scan des fichiers..."
# Scan de tous les fichiers utilisateurs
php /var/www/html/occ files:scan --all
# Scan du dossier AppData
php /var/www/html/occ files:scan-app-data
# Réparation de l'arborescence des fichiers si nécessaire
php /var/www/html/occ files:repair-tree || echo "⚠️ La réparation de l'arborescence a échoué, mais nous continuons..."

# Désactivation du mode maintenance
echo "🔓 Désactivation du mode maintenance..."
php /var/www/html/occ maintenance:mode --off

echo "✅ Vérification de l'intégrité terminée" 