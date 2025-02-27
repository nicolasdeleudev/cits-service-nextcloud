# Service Nextcloud

Ce service fournit une instance Nextcloud intégrée à l'infrastructure CITS.

## Fonctionnalités

- Stockage de fichiers sécurisé
- Synchronisation multi-appareils
- Partage de fichiers
- Calendrier (CalDAV) et contacts (CardDAV)
- Édition collaborative de documents
- Galerie photos
- Visioconférence

## Architecture

- **Base de données** : PostgreSQL 16
- **Serveur Web** : Apache avec support reverse proxy
- **Stockage** : Volumes Docker persistants
- **Proxy** : Traefik avec SSL/TLS
- **Hooks** : Scripts de personnalisation pre/post installation et mise à jour

## Configuration

### Variables d'environnement

Voir le fichier `.env.nextcloud` pour la liste complète des variables disponibles.

### Volumes

- `/var/www/html` : Installation Nextcloud
- `/var/www/html/data` : Données utilisateurs
- `/var/www/html/custom_apps` : Applications personnalisées
- `/var/www/html/config` : Configuration
- `/var/www/html/themes` : Thèmes personnalisés

### Hooks

Cinq points d'extension sont disponibles :
- `pre-installation` : Avant l'installation
- `post-installation` : Après l'installation
- `pre-upgrade` : Avant la mise à jour
- `post-upgrade` : Après la mise à jour
- `before-starting` : Avant chaque démarrage

## Utilisation

### Installation

1. Copiez les variables d'environnement nécessaires de `.env.nextcloud` vers `.env`
2. Ajoutez `nextcloud` à la liste des services dans `SERVICES`
3. Lancez l'installation avec `./run.sh`

### Commandes utiles

Accès à la ligne de commande Nextcloud (occ) :
```bash
docker exec --user www-data nextcloud php occ
```

### Maintenance

Vérification de l'état :
```bash
docker exec nextcloud curl -f http://localhost/status.php
```

## Sécurité

- Accès HTTPS uniquement
- Rate limiting configuré
- Headers de sécurité activés
- Reverse proxy sécurisé
- Isolation des conteneurs

## Sauvegarde

Les volumes suivants doivent être sauvegardés :
- `nextcloud-db-data`
- `nextcloud-data`
- `nextcloud-config`
- `nextcloud-custom-apps`
- `nextcloud-themes`
