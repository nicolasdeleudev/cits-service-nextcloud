# Service Nextcloud - ConsultIT Solution

Service de cloud privé sécurisé basé sur Nextcloud, avec support Collabora Online, Redis pour le cache, PostgreSQL, backups automatisés et intégration Traefik. Compatible socle CITS.

## 🚀 Fonctionnalités

- Instance Nextcloud sécurisée avec support SSL
- Édition collaborative avec Collabora Online
- Cache Redis pour les performances optimales
- Base de données PostgreSQL
- Backups automatisés avec hooks de maintenance
- Intégration SMTP pour les notifications
- Protection contre les attaques via Traefik
- Monitoring et métriques

## 📋 Prérequis

- Socle CITS installé et configuré
- Domaine et sous-domaine valides pour Nextcloud et Collabora
- Minimum 4GB RAM (8GB recommandé)
- 20GB d'espace disque minimum

## ⚙️ Configuration

1. Variables d'environnement requises :
```bash
# Dans .env
NEXTCLOUD_DB_PASSWORD=xxx        # Mot de passe PostgreSQL
NEXTCLOUD_ADMIN_USER=xxx        # Utilisateur admin Nextcloud
NEXTCLOUD_ADMIN_PASSWORD=xxx    # Mot de passe admin Nextcloud
COLLABORA_ADMIN_USER=xxx        # Utilisateur admin Collabora
COLLABORA_ADMIN_PASSWORD=xxx    # Mot de passe admin Collabora
NEXTCLOUD_URL_ESCAPED=xxx       # URL Nextcloud échappée (ex: nextcloud\\.example\\.fr)
```

2. Configuration SMTP (optionnelle) :
```bash
NEXTCLOUD_SMTP_HOST=xxx                   # Serveur SMTP
NEXTCLOUD_SMTP_NAME=xxx                   # Utilisateur SMTP
NEXTCLOUD_SMTP_PASSWORD=xxx               # Mot de passe SMTP
NEXTCLOUD_MAIL_DOMAIN=xxx                # Domaine mail
```

## 🛠 Utilisation

### Installation initiale
```bash
# Démarrage des services
./run.sh nextcloud

# Vérification des logs
docker logs -f nextcloud
```


### Backup/Restore
```bash
# Création d'un backup
./cli.sh backup create nextcloud

# Restauration
./cli.sh backup restore <backup_dir> nextcloud
```

## 🔒 Sécurité

- Certificats SSL automatiques via Let's Encrypt
- Protection contre les attaques DDOS
- Isolation réseau via Docker
- Headers de sécurité préconfigurés
- Rate limiting sur les endpoints sensibles
- Scripts de maintenance automatisés

## 📚 Documentation

- [Guide de déploiement](docs/deployment.md)
- [Configuration Collabora](docs/collabora.md)
- [Maintenance](docs/maintenance.md)
- [FAQ](docs/faq.md)

## 📝 Licence

Copyright © 2024 ConsultIT Solution. Tous droits réservés.
Voir le fichier [LICENSE](LICENSE) pour plus de détails.
