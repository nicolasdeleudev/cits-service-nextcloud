#!/bin/bash
set -eu

echo "=== Configuration des applications essentielles ==="

# Installation et configuration de Groupfolders
echo "🔧 Vérification de Groupfolders..."
if ! php /var/www/html/occ app:list | grep -q "groupfolders"; then
    echo "Installation de Groupfolders..."
    php /var/www/html/occ app:install groupfolders
else
    echo "✅ Groupfolders déjà installé"
fi

# Activation de Groupfolders
echo "🔧 Activation de Groupfolders..."
php /var/www/html/occ app:enable groupfolders

# Installation et configuration de Guests
echo "🔧 Vérification de Guests..."
if ! php /var/www/html/occ app:list | grep -q "guests"; then
    echo "Installation de Guests..."
    php /var/www/html/occ app:install guests
else
    echo "✅ Guests déjà installé"
fi

# Activation de Guests
echo "🔧 Activation de Guests..."
php /var/www/html/occ app:enable guests

# Installation et configuration de Notes
echo "🔧 Vérification de Notes..."
if ! php /var/www/html/occ app:list | grep -q "notes"; then
    echo "Installation de Notes..."
    php /var/www/html/occ app:install notes
else
    echo "✅ Notes déjà installé"
fi

# Activation de Notes
echo "🔧 Activation de Notes..."
php /var/www/html/occ app:enable notes

# Installation et configuration de Tables
echo "🔧 Vérification de Tables..."
if ! php /var/www/html/occ app:list | grep -q "tables"; then
    echo "Installation de Tables..."
    php /var/www/html/occ app:install tables
else
    echo "✅ Tables déjà installé"
fi

# Activation de Tables
echo "🔧 Activation de Tables..."
php /var/www/html/occ app:enable tables

# Installation et configuration de Collectives
echo "🔧 Vérification de Collectives..."
if ! php /var/www/html/occ app:list | grep -q "collectives"; then
    echo "Installation de Collectives..."
    php /var/www/html/occ app:install collectives
else
    echo "✅ Collectives déjà installé"
fi

# Activation de Collectives
echo "🔧 Activation de Collectives..."
php /var/www/html/occ app:enable collectives

# Vérification finale
echo "🔍 Vérification de la configuration finale :"
echo "- Groupfolders : $(php /var/www/html/occ app:list | grep -A 2 'groupfolders')"
echo "- Guests : $(php /var/www/html/occ app:list | grep -A 2 'guests')"
echo "- Notes : $(php /var/www/html/occ app:list | grep -A 2 'notes')"
echo "- Tables : $(php /var/www/html/occ app:list | grep -A 2 'tables')"
echo "- Collectives : $(php /var/www/html/occ app:list | grep -A 2 'collectives')"

echo "✅ Configuration des applications essentielles terminée" 