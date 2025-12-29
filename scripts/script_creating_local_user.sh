#!/bin/bash

#########################################################################
# Script creating local user
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
    echo -e "${TITLE}Création d'utilisateur local${NC}"
    echo ""

#boucle
while true
do
	#username request created
	read -p " quel est le nom du compte utilisateur a créé ? : " name

	#verification and creation of the user account if it exists
	if id "$name" &>/dev/null
	then
		echo -e "${RED}WARNING !${NC} le compte utilisateur existe déjà "
		echo ""
	
	else
		useradd "$name"
		break
	fi
done
# verification creation user
if [ $? -eq 0 ]
then
	echo -e "${GREEN}le compte utilisateur $name est bien créé!${NC}"
	echo ""
else
	echo -e "${RED}WARNING ! ${NC}le compte utilisateur $name n'a pas été créé !!!"
	echo ""
fi
exit 0
############################################################################