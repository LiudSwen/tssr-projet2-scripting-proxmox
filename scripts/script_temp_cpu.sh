#!/bin/bash
#############################
# Script temp cpu
# Jouveaux Nicolas
# 01/12/2025
##############################

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
# Script
#########################################################################

# menu name display
    echo -e "${TITLE}Température CPU${NC}"
    echo ""

echo -e "${GREEN}Vérification de la température du CPU${NC}"
echo "---"

# Checked if 'sensors' is installed
if command -v sensors &> /dev/null
then
# Filtering and executing the 'sensors' command to get CPU temperature
    sensors 2>/dev/null | grep -E 'Core |Package id'
    value=$(sensors 2>/dev/null | grep -E 'Core |Package id')
    
# Verification if sensors command returned a value
        if [ $? -eq 0 ];
        then
            echo -e "${GREEN}Capteurs détectés : Affichage des températures :${NC}"
            echo ""
        else
            echo -e "${RED}Aucun capteur CPU fonctionnel n'a été trouvé.${NC}"
            echo ""
        fi    
else
    # Si la commande n'est pas installée : affiche le message d'erreur
    echo "ATTENTION : La commande 'sensors' est introuvable."
    echo "Utiliser 'sudo apt install lm-sensors' pour l'installer"
    echo ""
fi

# Save information
save_info "Température CPU" "$value"
exit 0
############################################################################
