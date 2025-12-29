#!/bin/bash
#############################
# Script percent cpu
# Jouveaux Nicolas
# 30/11/2025
##############################

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

# function for save information in file
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

# menu name display
    echo -e "${TITLE}CPU %${NC}"
    echo ""


    # Data Recovery
CPU=$(vmstat 1 2 | tail -n 1)

PERCENT=$(echo "$CPU" | awk '{print $15}')

    # Usage calculation
CPU_USAGE=$(echo "100 - $PERCENT" | bc -l)

    # Displaying the result
        echo -e "${GREEN}Utilisation du CPU : $CPU_USAGE %${NC}"
        echo ""

value="$CPU_USAGE"
save_info "CPU %" "$value"
exit 0
############################################################################