#!/bin/bash

#########################################################################
# Template save information
# Chicaud Matthias
# 07/12/2025
#########################################################################

#########################################################################
# INFORMATION
#########################################################################

# 1. Copy the VARIABLE section into your child script.
# 2. CHOOSE ONE OPTION:
#       USER: info_target="wilder"
#       COMPUTER: info_target=$(hostname)
# 3. Copy the save_info() function into the FUNCTIONS section.
# 4. Retrieve the information.
# 5. Format this information into value.
# 6. Call save_info "Name of information" "$value".

# The generated file will be: info_<target>_<yyyymmdd>.txt
# Always use >> to add information to the same file for the day.

#########################################################################
# Variable
#########################################################################

# Variable for save_info function

# info_target="wilder" # Uncomment for user script
# info_target="$(hostname)" # Uncomment for computer script
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

# Example:
# value="$(lsb_release -ds 2>/dev/null)"
# save_info "Version de l'OS" "$value"

value="raw_value"
save_info "Name of information" "$value"

#########################################################################