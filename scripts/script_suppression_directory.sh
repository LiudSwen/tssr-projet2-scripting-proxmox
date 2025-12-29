#!/bin/bash

#########################################################################
# Script suppression repertory
# Paisant Franck
# Execution SUDO
# 04/12/2025
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
    echo -e "${TITLE}Suppression d'un répertoire${NC}"
    echo ""
while true
do
    # request for the name of the directory to be deleted.
    echo -e "${LABEL}Exemple: /tmp/monrepertoire ou /home/user/repertoire${NC}"
    echo ""
    read -p "Quel est le chemin et le nom du répertoire à supprimer ?: " repertory

    # verification of the directory to be deleted.
    if [ -d "$repertory" ]
    then
        echo -e "${GREEN} le $repertory existe bien !${NC}"
        read -p "Confirmer vous la suppression o/n ?" choix
            echo ""
            if [ "$choix" = "o" ]
            then
                rm -r "$repertory"
                echo -e "${RED}Le $repertory a été supprimé avec succès!!${NC}"
                echo ""
                break
            elif [ "$choix" = "n" ]
            then
                echo -e "${RED}WARNING le $repertory n'a pas été supprimé !!!${NC}"
                echo""
                break
            else
                echo -e "${RED}Choix invalide${NC}"
                continue
            fi    
    else 
    echo -e "${RED}WARNING !!!${NC} le $repertory n'existe pas !!!!"
    continue
    fi
done     
exit 0
############################################################################