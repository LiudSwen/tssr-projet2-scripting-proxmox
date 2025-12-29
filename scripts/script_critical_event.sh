#!/bin/bash

#########################################################################
# Script add critical events
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

# Variable for save_info function

info_target="$(hostname)"
info_date="$(date +%Y%m%d)"
info_dir="/home/$(whoami)/Documents/info"
info_file="$info_dir/info_${info_target}_${info_date}.txt"

#########################################################################
# Function
#########################################################################

# Function for save information in file
save_info()
{
    local label="$1"
    local value="$2"
    local time_save_info="$(date +%H:%M:%S)"
    mkdir -p "$info_dir"
    echo "[$time_save_info] $label : $value" >> $info_file
}

#########################################################################
# Script
#########################################################################

# Title
echo -e "${TITLE}10 derniers événements critiques${NC}"
echo ""

# Filtering events display
echo -e "${YELLOW}Filtrage des événements critiques en cours${NC}"
echo ""

# Use journalctl to display the last 10 critical events (0 = Emergency, 1 = Alert, 2 = Critical)
journalctl -p 0..2 -n 10 --no-pager
value=$(journalctl -p 0..2 -n 10 --no-pager)

# Result verification
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}Affichage des 10 derniers événements critiques terminé${NC}"
else
    echo ""
    echo -e "${RED}Erreur lors de la récupération des événements critiques${NC}"
    exit 1
fi

# Save information
save_info "10 derniers événements critiques" "$value"
exit 0