#!/bin/bash

#########################################################################
# Script add group administration
# Paisant Franck
# Execution SUDO
# 01/12/2025
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
    echo -e "${TITLE}Ajout à un groupe d'administration${NC}"
    echo ""
# boucle
while true
do
    # user to add group
    read -p " Quel est le nom de l'utilisateur à ajouter ?: " user

    #verify if user is created
    if ! id "$user" &> /dev/null
    then
        echo -e " ${RED}Warning !!!${NC} L'utilisateur $user n'existe pas !!! "
        echo ""
        continue
    fi

    # which group the user is added to
    read -p " A quel groupe d'administration voulez vous ajouter $user ? :" group

    # verification if the group exists
    if ! getent group "$group" &> /dev/null
    then
        echo -e " ${RED}Warning !!!${NC} Le groupe d'administration n'existe pas !!!!! "
        echo ""
        continue
    fi
    #verification if user in the group
    if groups "$user" | grep -w "$group" &> /dev/null
    then
        echo -e " ${RED}WARNING !!!${NC} $user fait déjà partie du $group "
        echo ""
        continue
    fi

    #verification ok add user off group    
    usermod -aG "$group" "$user"
    break
        
done  

# verification the user has been added to the administration group
if groups "$user" | grep -w "$group" &> /dev/null
then
    echo -e "${GREEN} $user a bien été ajouté au groupe d'administration $group${NC} "
    echo ""
else
    echo -e " ${RED}WARNING !!!${NC} $user n'a pas été ajouté au groupe d'administration $group "
    echo ""
fi
exit 0
###############################################################################################