#!/bin/bash

#########################################################################
# Script add remote control
# Jouveaux Nicolas
# Execution SUDO
# 11/12/2025
#########################################################################

#########################################################################
#                     Define colors with variables                      #
#########################################################################

# For menu titles: Underlined and yellow
TITLE='\033[4;33m'
# Used for labels: purple
LABEL='\033[0;35m'
# Used for FALSE: red
RED='\033[0;31m'
# Used for TRUE: green
GREEN='\033[0;32m'
# Reset color at end of line
NC='\033[0m'

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
echo -e "${TITLE}Connexion à un ordinateur distant${NC}"
echo ""

# Wich user
while true
do
    read -p "Quel est le nom d'utilisateur distant ? : " user

    echo""
    
# Verification if user exists
    echo -e "${YELLOW}Vérification de l'utilisateur $user${NC}"
    if id "$user" >/dev/null 2>&1
    then
        echo -e "${GREEN}Utilisateur $user trouvé.${NC}"
        break
    else
        echo -e "${RED}Erreur : l'utilisateur $user n'existe pas sur ce système.${NC}"
        read -p "Voulez-vous réessayer ? (o/n) : " retry
        [ "$retry" != "o" ] && exit 1
    fi
done

echo ""

# Wich host
while true
do
    read -p "Quelle est l'adresse IP ou le nom de l'ordinateur ? : " address

    echo""
    
# Verification if host exists
        echo -e "${YELLOW}Vérification de l'adresse $address${NC}"

        echo""

        if ping -c 1 -W 2 "$address" >/dev/null 2>&1
        then
            echo -e "${GREEN}L'adresse $address a été trouvé.${NC}"
            break
        else
            echo -e "${RED}Erreur : l'adresse $address n'existe pas ou n'est pas joignable.${NC}"
            read -p "Voulez-vous réessayer ? (o/n) : " retry
            [ "$retry" != "o" ] && exit 1
        fi
done

echo ""
echo -e "${GREEN}Connexion en cours à ${user}@${address}${NC}"
echo ""

# Tentative de connexion SSH
ssh ${user}@${address}

# Vérification de la connexion
if [ $? -eq 0 ]
then
	echo ""
	echo -e "Déconnexion réussie"
	
else
   echo ""
    echo -e "${RED}WARNING ! ${NC}La connexion à ${user}@${address} a échoué !!!"
    echo ""
fi

exit 0