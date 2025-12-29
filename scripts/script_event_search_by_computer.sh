#!/bin/bash

#########################################################################
# Script event search by computer
# Chicaud Matthias
# Execution SUDO
# 16/12/2025
#########################################################################

#########################################################################
#                     Define colors with variables                      #
#########################################################################

# For menu titles: Underlined and yellow
TITLE='\033[1;33m'
# Used for labels: purple
LABEL='\033[1;94m'
# Used for FALSE: red
RED='\033[0;91m'
# Used for TRUE: green
GREEN='\033[0;32m'
# Reset color at end of line
NC='\033[0m'
# White
WHITE='\033[1;97m'

#########################################################################

#########################################################################
# Variable
#########################################################################

info_target="wilder" # Uncomment for user script
info_date="$(date +%Y%m%d)"
info_dir="/tmp/info"
info_file="$info_dir/info_${info_target}_${info_date}.txt"

#########################################################################
# Function
#########################################################################

# Function for save information in file
save_info()
{
    local label="$1"
    local value="$2"
    local time_save_info="$(date +%H:%M:%S)"
    mkdir -p "$info_dir"
    echo "[$time_save_info] $label : $value" >> "$info_file"
}

#########################################################################
# Script
#########################################################################

# Title
echo -e "${TITLE}Recherche d'événement par ordinateur${NC}"
echo ""

# menu name display
# Recherche par utilisateur (3ᵉ champ)
read -p "Nom de l'ordinateur : " computer
if ( grep -q "$computer" /var/log/log_evt.log )
then
    echo -e "${TITLE}Recherche dans le fichier log_evt.log pour l'ordinateur : $computer${NC}"
    sleep 1
    value=$(grep -F "$computer" /var/log/log_evt.log)
    if [[ -z "$value" ]]; 
    then
        echo -e "${RED}WARNING !${NC} Aucun événement trouvé pour l'ordinateur : $user"
        echo ""
    else
        echo -e "${GREEN}Événements trouvés !${NC}"
        echo ""
    fi
else
    echo -e "${RED}WARNING !${NC} L'ordinateur n'existe pas dans ce fichier."
fi

save_info "Recherche d'événement par ordinateur" "$value"

#########################################################################