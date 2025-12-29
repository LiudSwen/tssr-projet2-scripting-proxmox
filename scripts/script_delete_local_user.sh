#!/bin/bash

#########################################################################
# Script delete local user
# Chicaud Matthias
# Execution SUDO
# 07/12/2025
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
# Variable
#########################################################################

#########################################################################
# Function
#########################################################################

#########################################################################
# Script
#########################################################################

# menu name display
    clear
    echo -e "${TITLE}Suppression d'utilisateur local${NC}"
    echo ""

#boucle
while true
do
	#username request created
	read -p "Quel est le nom du compte utilisateur à supprimer ? : " name

	#verification and creation of the user account if it exists
	if ( ! id "$name" ) &>/dev/null
	then
		echo -e "${RED}WARNING !${NC} le compte utilisateur n'existe pas. "
		echo ""
        continue
	else
		userdel "$name"
        if [ $? -eq 0 ]
        then
            echo -e "${GREEN}le compte utilisateur $name est bien supprimé!${NC}"
            echo ""
        else
            echo -e "${RED}WARNING ! ${NC}le compte utilisateur $name n'a pas été supprimé."
            echo ""
        fi
		break
	fi
done
# verification creation user

exit 0
############################################################################