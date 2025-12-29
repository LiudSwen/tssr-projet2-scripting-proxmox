#!/bin/bash
#############################
# Script firewall
# Jouveaux Nicolas
# Execution SUDO
# 01/12/2025
##############################
#########################################################################
# Variable
#########################################################################

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
# white
WHITE='\033[1;97m'

#########################################################################

#########################################################################
# Script
#########################################################################

# menu name display
    echo -e "${TITLE}Activation du pare-feu${NC}"
    echo ""

# Display options to enable or disable the firewall 
echo -e "${TITLE}1) Activer le pare-feu${NC}"
echo -e "${TITLE}2) Désactiver le pare-feu${NC}"
echo ""
read -p "➤ Choisis 1 ou 2 : " reply

if [ "$reply" = "1" ]; then
    echo "Activation du pare-feu"
    sudo ufw --force enable >/dev/null 2>&1
    echo -e "${GREEN}Pare-feu activé${NC}"
    sudo ufw status verbose
else
    echo "Désactivation du pare-feu"
    sudo ufw disable >/dev/null 2>&1
    echo -e "${RED}Pare-feu désactivé => WARNING OPEN-BAR${NC}"
    sudo ufw status verbose
fi
exit 0
############################################################################