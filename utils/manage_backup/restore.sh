#!/bin/bash
set -e

# Configuration
RESTORE_TMP="/restore_tmp"
NEXTCLOUD_ROOT="/nextcloud"
NEXTCLOUD_USER=33
NEXTCLOUD_GROUP=33

# Vérification des variables d'environnement requises
for var in DB_HOST DB_USER DB_NAME; do
    if [ -z "${!var}" ]; then
        echo "❌ Erreur : La variable $var doit être définie"
        exit 1
    fi
done

# Vérification de l'archive
BACKUP_FILE="$RESTORE_TMP/backup.tar.gz"
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Erreur : Archive de backup non trouvée"
    exit 1
fi

echo "🔄 Démarrage de la restauration Nextcloud..."

# Extraction de l'archive
echo "📦 Extraction de l'archive..."
if ! tar xzf "$BACKUP_FILE" -C "$RESTORE_TMP"; then
    echo "❌ Erreur lors de l'extraction de l'archive"
    exit 1
fi

# Vérification du fichier de base de données
if [ ! -f "$RESTORE_TMP/db.dump" ]; then
    echo "❌ Erreur : Fichier de base de données manquant dans l'archive"
    exit 1
fi

# Restauration de la base de données
echo "💾 Restauration de la base de données PostgreSQL..."
if ! pg_restore -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" --clean --if-exists "$RESTORE_TMP/db.dump"; then
    echo "⚠️ Attention : Des erreurs sont survenues pendant la restauration"
    echo "ℹ️ Ces erreurs sont normales si certaines tables n'existaient pas"
fi

# Restauration des données Nextcloud
echo "📂 Restauration des fichiers de configuration..."
if [ -f "$RESTORE_TMP/config.tar.gz" ]; then
    rm -rf "${NEXTCLOUD_ROOT}/config"
    mkdir -p "${NEXTCLOUD_ROOT}/config"
    if ! tar xzf "$RESTORE_TMP/config.tar.gz" -C "${NEXTCLOUD_ROOT}/config"; then
        echo "❌ Erreur lors de la restauration de la configuration"
        exit 1
    fi
    chown -R ${NEXTCLOUD_USER}:${NEXTCLOUD_GROUP} "${NEXTCLOUD_ROOT}/config"
else
    echo "⚠️ Attention : Pas de fichiers de configuration à restaurer"
fi

echo "📂 Restauration des données utilisateurs..."
if [ -f "$RESTORE_TMP/data.tar.gz" ]; then
    rm -rf "${NEXTCLOUD_ROOT}/data"
    mkdir -p "${NEXTCLOUD_ROOT}/data"
    if ! tar xzf "$RESTORE_TMP/data.tar.gz" -C "${NEXTCLOUD_ROOT}/data"; then
        echo "❌ Erreur lors de la restauration des données utilisateurs"
        exit 1
    fi
    chown -R ${NEXTCLOUD_USER}:${NEXTCLOUD_GROUP} "${NEXTCLOUD_ROOT}/data"
else
    echo "⚠️ Attention : Pas de données utilisateurs à restaurer"
fi

echo "📂 Restauration des thèmes..."
if [ -f "$RESTORE_TMP/themes.tar.gz" ]; then
    rm -rf "${NEXTCLOUD_ROOT}/themes"
    mkdir -p "${NEXTCLOUD_ROOT}/themes"
    if ! tar xzf "$RESTORE_TMP/themes.tar.gz" -C "${NEXTCLOUD_ROOT}/themes"; then
        echo "❌ Erreur lors de la restauration des thèmes"
        exit 1
    fi
    chown -R ${NEXTCLOUD_USER}:${NEXTCLOUD_GROUP} "${NEXTCLOUD_ROOT}/themes"
else
    echo "⚠️ Attention : Pas de thèmes à restaurer"
fi

# Nettoyage
rm -f "$RESTORE_TMP/db.dump" "$RESTORE_TMP/config.tar.gz" "$RESTORE_TMP/data.tar.gz" "$RESTORE_TMP/themes.tar.gz"

echo "✅ Restauration Nextcloud terminée avec succès"
exit 0 