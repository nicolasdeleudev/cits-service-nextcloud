#!/bin/bash

echo -e "${GREEN}=== Initialisation des répertoires Nextcloud ===${NC}"

# Définition des chemins de base
WORKDIR="${PROJECT_ROOT}/workdir"

# Structure pour Nextcloud
PATHS=(
    # Dossiers principaux du mailserver
    "nextcloud/data"      # Données Nextcloud (exemple, a modifier)
    "nextcloud/config"         # Configurations (exemple, a modifier)
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