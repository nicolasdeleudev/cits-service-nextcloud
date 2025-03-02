#!/bin/bash
set -eu

echo "=== Configuration de Nextcloud Office (Collabora) ==="

# Récupération du domaine de base depuis les domaines de confiance
NEXTCLOUD_DOMAIN=$(php /var/www/html/occ config:system:get trusted_domains | grep -v "localhost" | head -n 1)
if [ -z "${NEXTCLOUD_DOMAIN}" ]; then
    echo "❌ Erreur : Impossible de récupérer le domaine Nextcloud depuis trusted_domains"
    exit 1
fi

# Extraction du domaine de base
BASE_DOMAIN=$(echo "$NEXTCLOUD_DOMAIN" | sed -E 's/^nextcloud\.//')
if [ -z "${BASE_DOMAIN}" ]; then
    echo "❌ Erreur : Impossible d'extraire le domaine de base"
    exit 1
fi

# Vérification si richdocuments est installé
if ! php /var/www/html/occ app:list | grep -q "richdocuments"; then
    echo "🔧 Installation de Nextcloud Office..."
    php /var/www/html/occ app:install richdocuments
else
    echo "✅ Nextcloud Office déjà installé"
fi

# Activation de l'application
echo "🔧 Activation de Nextcloud Office..."
php /var/www/html/occ app:enable richdocuments

# Configuration de l'URL du serveur Collabora
COLLABORA_URL="https://collabora.${BASE_DOMAIN}"
echo "🔧 Configuration de l'URL Collabora : $COLLABORA_URL"
php /var/www/html/occ config:app:set richdocuments wopi_url --value="$COLLABORA_URL"

# Désactivation de la vérification du certificat
echo "🔧 Configuration de la vérification du certificat..."
php /var/www/html/occ config:app:set richdocuments disable_certificate_verification --value="no"

# Configuration de la liste blanche WOPI
echo "🔧 Configuration de la liste blanche WOPI..."
php /var/www/html/occ config:app:set richdocuments wopi_allowlist --value="172.16.42.0/24"

# Vérification finale
echo "🔍 Vérification de la configuration finale :"
echo "- Version installée : $(php /var/www/html/occ app:list | grep -A 2 'richdocuments')"
echo "- URL Collabora : $(php /var/www/html/occ config:app:get richdocuments wopi_url)"
echo "- Vérification certificat : $(php /var/www/html/occ config:app:get richdocuments disable_certificate_verification)"
echo "- Liste blanche WOPI : $(php /var/www/html/occ config:app:get richdocuments wopi_allowlist)"

# Validation finale
CONFIGURED_URL=$(php /var/www/html/occ config:app:get richdocuments wopi_url)
CERT_VERIFY=$(php /var/www/html/occ config:app:get richdocuments disable_certificate_verification)
WOPI_ALLOWLIST=$(php /var/www/html/occ config:app:get richdocuments wopi_allowlist)

if [ "$CONFIGURED_URL" = "$COLLABORA_URL" ] && \
   [ "$CERT_VERIFY" = "no" ] && \
   [ "$WOPI_ALLOWLIST" = "172.16.42.0/24" ]; then
    echo "✅ Configuration de Nextcloud Office terminée avec succès"
else
    echo "❌ Erreur : La configuration n'est pas correcte"
    echo "URL configurée : $CONFIGURED_URL"
    echo "Vérification certificat : $CERT_VERIFY"
    echo "Liste blanche WOPI : $WOPI_ALLOWLIST"
    exit 1
fi 