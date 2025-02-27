# Post-Upgrade Hook

Ce dossier contient les scripts qui seront exécutés **après** la mise à jour de Nextcloud.

## Utilisation

1. Créez vos scripts shell avec l'extension `.sh`
2. Rendez-les exécutables avec `chmod +x script.sh`
3. Les scripts seront exécutés dans l'ordre alphabétique

## Cas d'utilisation typiques

- Réactivation des applications
- Mise à jour des applications tierces
- Nettoyage post-mise à jour
- Vérification de l'intégrité
- Optimisation de la base de données
