#!/bin/bash

# Retourne la catégorie de ce CLI
get_category() {
    echo "nextcloud"
}

# Retourne la description de ce CLI
get_description() {
    echo "Gestion du service Nextcloud"
}

# Fonction d'aide pour ce CLI
cli_main_help() {
    echo -e "  ${YELLOW}$(get_category)${NC} - $(get_description)"
    if [ "$1" = "detailed" ]; then
        echo -e "\nCommandes disponibles :"
        # Utiliser le chemin absolu du répertoire du script
        local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        for cli_script in "$script_dir/cli_repository"/*.sh; do
            if [ -f "$cli_script" ]; then
                source "$cli_script"
                if type cli_help &>/dev/null; then
                    cli_help
                fi
                # Nettoyage des fonctions pour éviter les doublons
                unset -f cli_help cli_execute
            fi
        done
    fi
}

# Fonction pour exécuter une commande
execute_command() {
    local command="$1"
    shift
    
    # Utiliser le chemin absolu du répertoire du script
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local cli_script="$script_dir/cli_repository/${command}.sh"
    
    if [ -f "$cli_script" ]; then
        source "$cli_script"
        if type cli_execute &>/dev/null; then
            cli_execute "$@"
        else
            echo -e "${RED}Error: Command implementation not found${NC}"
            return 1
        fi
    else
        echo -e "${RED}Error: Command '$command' not found${NC}"
        cli_main_help "detailed"
        return 1
    fi
} 