#!/bin/bash

echo -e "${GREEN}=== Initialisation des répertoires Nextcloud ===${NC}"

# Définition des chemins de base
WORKDIR="${PROJECT_ROOT}/workdir"

# Structure pour Nextcloud
PATHS=(
    "nextcloud/custom_apps"
    "tmp/backup/nextcloud"
    "tmp/restore/nextcloud"
)

# Création des répertoires
echo -e "${YELLOW}Création de la structure des répertoires...${NC}"
for path in "${PATHS[@]}"; do
    full_path="${WORKDIR}/${path}"
    if [ ! -d "$full_path" ]; then
        echo -e "${YELLOW}Création du répertoire : ${full_path}${NC}"
        mkdir -p "$full_path"
    else
        echo -e "${GREEN}Le répertoire existe déjà : ${full_path}${NC}"
    fi
done

echo -e "${GREEN}=== Initialisation des répertoires Mailserver terminée ===${NC}" 