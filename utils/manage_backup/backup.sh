#!/bin/bash
set -e

# Configuration
BACKUP_TMP="/backup_tmp"

# Vérification des variables d'environnement requises
for var in DB_HOST DB_USER DB_NAME; do
    if [ -z "${!var}" ]; then
        echo "❌ Erreur : La variable $var doit être définie"
        exit 1
    fi
done

# Vérification de la connexion à la base de données
echo "🔍 Vérification de la connexion à la base de données..."
if ! pg_isready -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME"; then
    echo "❌ Erreur : Impossible de se connecter à la base de données"
    echo "ℹ️ Vérifiez que les services sont bien démarrés avec : ./run.sh nextcloud"
    exit 1
fi

# Nettoyage initial
rm -rf "$BACKUP_TMP"/*
mkdir -p "$BACKUP_TMP"

echo "🔄 Démarrage de la sauvegarde Nextcloud..."

# Sauvegarde de la base de données
echo "💾 Sauvegarde de la base de données PostgreSQL..."
if ! pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -F c -f "$BACKUP_TMP/db.dump"; then
    echo "❌ Erreur lors de la sauvegarde de la base de données"
    exit 1
fi

# Sauvegarde des données Nextcloud
echo "📂 Sauvegarde des fichiers de configuration..."
if ! tar czf "$BACKUP_TMP/config.tar.gz" -C /nextcloud/config .; then
    echo "❌ Erreur lors de la sauvegarde de la configuration"
    exit 1
fi

echo "📂 Sauvegarde des données utilisateurs..."
if ! tar czf "$BACKUP_TMP/data.tar.gz" -C /nextcloud/data .; then
    echo "❌ Erreur lors de la sauvegarde des données utilisateurs"
    exit 1
fi

echo "📂 Sauvegarde des thèmes..."
if ! tar czf "$BACKUP_TMP/themes.tar.gz" -C /nextcloud/themes .; then
    echo "❌ Erreur lors de la sauvegarde des thèmes"
    exit 1
fi

# Création de l'archive finale
echo "🗜️ Création de l'archive finale..."
if ! tar czf "$BACKUP_TMP/backup.tar.gz" -C "$BACKUP_TMP" db.dump config.tar.gz data.tar.gz themes.tar.gz; then
    echo "❌ Erreur lors de la création de l'archive finale"
    exit 1
fi

# Nettoyage des fichiers intermédiaires
rm -f "$BACKUP_TMP/db.dump" "$BACKUP_TMP/config.tar.gz" "$BACKUP_TMP/data.tar.gz" "$BACKUP_TMP/themes.tar.gz"

echo "✅ Sauvegarde Nextcloud terminée avec succès"
exit 0 