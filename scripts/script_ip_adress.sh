#!/bin/bash

#########################################################################
# Script show ip adress, masque and gateway
# Chicaud Matthias
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
    echo "[$time_save_info] $label : $value" >> "$info_file"
}

#########################################################################
# Script
#########################################################################

# Title
echo -e "${TITLE}Adresse IP, masque et passerelle${NC}"
echo ""

# Retrieve IP / mask
ip_mask="$(ip -o -f inet addr | awk '{print  $4}' | head -n 1)"

# Retrieve gateway
gateway="$(ip route | grep default | awk '{print $3}')"

# Save information
value="IP / Mask : $ip_mask | Passerelle : $gateway"
echo -e "${GREEN}$value${NC}"
echo ""
save_info "Adresse IP, masque et passerelle" "$value"

#########################################################################