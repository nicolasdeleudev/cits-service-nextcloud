# Before-Starting Hook

Ce dossier contient les scripts qui seront exécutés **avant** chaque démarrage de Nextcloud.

## Utilisation

1. Créez vos scripts shell avec l'extension `.sh`
2. Rendez-les exécutables avec `chmod +x script.sh`
3. Les scripts seront exécutés dans l'ordre alphabétique

## Cas d'utilisation typiques

- Configuration dynamique des paramètres
- Vérification des services externes
- Ajustement des permissions
- Initialisation des caches
- Configuration des tâches cron
