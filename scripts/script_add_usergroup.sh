#!/bin/bash

#########################################################################
# Script add usergroup
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

# Menu name display
    echo -e "${TITLE}Ajout d'un utilisateur à un groupe${NC}"
    echo ""

while true
do
# Select user
    while true
    do
        read -p "Quel est le nom de l'utilisateur à ajouter ? : " user
        if id "$user" &>/dev/null
        then
            break
        else
            echo -e "${RED}Erreur : l'utilisateur $user n'existe pas sur ce système.${NC}"
        fi
    done
    echo ""

# Wich group
    read -p "Dans quel groupe voulez-vous ajouter $user ? : " group
    echo ""

# Verification and creation of group if not exist
if ! getent group "$group" &>/dev/null
then
    echo -e "${RED}Attention : le groupe $group n'existe pas.${NC}"
    echo ""
    read -r -p "Voulez-vous créer le groupe $group maintenant ? (o/N) : " response
    echo ""
    
# Check user response
    if [[ "${response,,}" == "o"* ]]
    then
        echo "Création du groupe $group."
        echo ""
        if groupadd "$group"
        then
            echo -e "${GREEN}Succès : Le groupe $group a été créé.${NC}"
            echo ""
        else
            echo -e "${RED}Échec de la création du groupe $group.${NC}"
            exit 1 
        fi
    else
        echo "Opération annulée."
        exit 1
    fi
fi

# Verification if user is already in group
    if groups $user | grep -qw $group
    then
        echo -e "${RED}Avertissement : $user fait déjà partie du groupe $group.${NC}"
        exit 1
    fi
    
# Add user to group
    echo "Ajout de l'utilisateur $user au groupe $group"
    echo ""
    if usermod -aG $group $user
    then
        echo -e "${GREEN}SUCCÈS : $user a bien été ajouté au groupe $group.${NC}"
        exit 0
    else
        echo -e "${RED}ÉCHEC CRITIQUE : impossible d'ajouter $user au groupe $group.${NC}"
        exit 1
    fi

done
exit 0
############################################################################