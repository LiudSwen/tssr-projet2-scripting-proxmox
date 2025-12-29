#!/bin/bash

#########################################################################
# Script change password
# Jouveaux Nicolas
# Execution SUDO
# 09/12/2025
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
echo -e "${TITLE}Changement du mot de passe d'un utilisateur${NC}"
echo ""

while true
do
    # Verification and input of the user name
    read -p "Nom de l'utilisateur dont vous voulez changer le mot de passe : " user

    if id "$user" &>/dev/null
    then
        echo -e "Utilisateur trouvé : ${GREEN}$user${NC}"
        echo ""
        break
    else
        echo -e "${RED}Erreur : l'utilisateur $user n'existe pas.${NC}"
    fi
done

# Confirmation before proceeding
echo -e "Voulez-vous vraiment changer le mot de passe de ${GREEN}$user${NC}"
read -r -p "Confirmez-vous cette action ? (o/N) : " confirm
if [[ ! "$confirm" =~ ^[oO]$ ]]
then
    echo -e "${RED}Opération annulée.${NC}"
    exit 0
fi

echo ""

# Change password
if passwd "$user"; then
    echo ""
    echo -e "${GREEN}Le mot de passe de $user a été modifié avec succès !${NC}"
    echo ""
    exit 0
else
    echo ""
    echo -e "${RED}ÉCHEC : Une erreur est survenue lors du changement de mot de passe.${NC}"
    echo ""
    exit 1
fi
exit 0
############################################################################