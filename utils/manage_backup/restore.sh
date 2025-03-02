#!/bin/bash
set -e

# Configuration
RESTORE_TMP="/restore_tmp"
NEXTCLOUD_ROOT="/nextcloud"
NEXTCLOUD_USER=33
NEXTCLOUD_GROUP=33

# Vérification des variables d'environnement requises
for var in POSTGRES_USER POSTGRES_DB PGPASSWORD; do
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

# Vérification des fichiers extraits
if [ ! -f "$RESTORE_TMP/db.dump" ]; then
    echo "❌ Erreur : Fichier de base de données manquant dans l'archive"
    exit 1
fi

# Restauration de la base de données
echo "💾 Restauration de la base de données..."
if ! pg_restore -h localhost -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists "$RESTORE_TMP/db.dump"; then
    echo "⚠️ Attention : Des erreurs sont survenues pendant la restauration"
    echo "ℹ️ Ces erreurs sont normales si certaines tables n'existaient pas"
fi

# Restauration des fichiers de configuration
echo "📂 Restauration des fichiers de configuration..."
if [ -f "$RESTORE_TMP/config.tar.gz" ]; then
    # Suppression du contenu sans supprimer le point de montage
    find "${NEXTCLOUD_ROOT}/config" -mindepth 1 -delete
    if ! tar xzf "$RESTORE_TMP/config.tar.gz" -C "${NEXTCLOUD_ROOT}/config"; then
        echo "❌ Erreur lors de la restauration de la configuration"
        exit 1
    fi
    chown -R ${NEXTCLOUD_USER}:${NEXTCLOUD_GROUP} "${NEXTCLOUD_ROOT}/config"
else
    echo "⚠️ Attention : Pas de fichiers de configuration à restaurer"
fi

# Restauration des données utilisateurs
echo "📂 Restauration des données utilisateurs..."
if [ -f "$RESTORE_TMP/data.tar.gz" ]; then
    # Suppression du contenu sans supprimer le point de montage
    find "${NEXTCLOUD_ROOT}/data" -mindepth 1 -delete
    if ! tar xzf "$RESTORE_TMP/data.tar.gz" -C "${NEXTCLOUD_ROOT}/data"; then
        echo "❌ Erreur lors de la restauration des données utilisateurs"
        exit 1
    fi
    chown -R ${NEXTCLOUD_USER}:${NEXTCLOUD_GROUP} "${NEXTCLOUD_ROOT}/data"
else
    echo "⚠️ Attention : Pas de données utilisateurs à restaurer"
fi

# Restauration des thèmes
echo "📂 Restauration des thèmes..."
if [ -f "$RESTORE_TMP/themes.tar.gz" ]; then
    # Suppression du contenu sans supprimer le point de montage
    find "${NEXTCLOUD_ROOT}/themes" -mindepth 1 -delete
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