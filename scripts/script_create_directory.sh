#!/bin/bash

#########################################################################
# Script create directory
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
    echo -e "${TITLE}Création d'un répertoire${NC}"
    echo ""
while true
do
    # request for the name of the directory to be deleted.
    echo -e "${LABEL}Exemple: /tmp/monrepertoire ou /home/user/repertoire${NC}"
    echo ""
    read -p "Quel est le chemin et le nom du répertoire à créer ?: " directory

    # verification of the directory to be deleted.
    if [ ! -d "$directory" ]
    then
        mkdir "$directory"
        if [ $? -eq 0 ]
        then
            echo -e "${GREEN}le dossier $directory à été créé${NC}"
            break
        else
            echo -e "${RED}WARNING :${NC} le dossier "$directory" n'a pas été créé !!!"
            break
        fi
    else 
    echo -e "${RED}WARNING :${NC} le dossier $directory existe déjà, veuillez proposez un autre chemin avec un nom valide :"
    continue
    fi
done     
exit 0

############################################################################