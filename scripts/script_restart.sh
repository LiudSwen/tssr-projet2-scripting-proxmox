#!/bin/bash

#########################################################################
# Script for restart computer
# Paisant Franck
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
# Variable
#########################################################################

countdown=5
machine=$(hostname)

#########################################################################

#########################################################################
# Script
#########################################################################

echo -e "${TITLE}Compte à rebours avant redémarrage de $machine:${NC}"
echo ""
while [ ! $countdown -eq 0 ];
do
    echo "$countdown"
    let countdown=$countdown-1
    sleep 1
done

echo -e "${GREEN}Redémarrage de la $machine en cours  !!${NC}"
sleep 1

reboot &> /dev/null &

exit 0

#########################################################################