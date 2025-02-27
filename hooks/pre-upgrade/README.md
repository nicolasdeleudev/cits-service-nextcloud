# Pre-Upgrade Hook

Ce dossier contient les scripts qui seront exécutés **avant** la mise à jour de Nextcloud.

## Utilisation

1. Créez vos scripts shell avec l'extension `.sh`
2. Rendez-les exécutables avec `chmod +x script.sh`
3. Les scripts seront exécutés dans l'ordre alphabétique

## Cas d'utilisation typiques

- Sauvegarde des données
- Vérification de l'espace disque
- Désactivation temporaire des applications
- Nettoyage des caches
- Vérification des prérequis de mise à jour
