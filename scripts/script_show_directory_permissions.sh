#!/bin/bash

#########################################################################
# Script show directory permission
# Chicaud Matthias
# 17/12/2025
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
    
    echo -e "${TITLE}Droits/Permissions de l'utilisateur sur un dossier${NC}"
    echo ""

# Wich user
    read -p "Quel utilisateur ? : " username
    read -p "Quel dossier (chemin) :" dir

# Verification if user exist
if ! id "$username" &> /dev/null
then
    echo -e "${RED}WARNING !${NC} Utilisateur invalide : $username"
    exit 1
fi
# Verification if directory exist
if [ ! -d "$dir" ]
then
    echo -e "${RED}WARNING !${NC} Dossier invalide : $dir"
    exit 1
fi

# Verification Owner of this directory
owner=$(stat -c '%U' "$dir")
# Verification group of this directory
group=$(stat -c '%G' "$dir")
# Verification access right of this directory
perm=$(stat -c '%a' "$dir")

# Get access right in octal (ex: 755)
owner_perm=$(echo $perm | cut -c1)
group_perm=$(echo $perm | cut -c2)
other_perm=$(echo $perm | cut -c3)

echo -e "${GREEN}Droits effectifs pour $username${NC}"

# Give the right answer if the user is Owner, Group or Others
if [ "$username" == "$owner" ]
then
    echo "Statut (en octale) : Propriétaire (owner)"
    echo "Permissions : $owner_perm"
    value="$owner_perm"
elif id -nG "$username" | grep -qw "$group" 2> /dev/null
then
    echo "Statut (en octale) : Membre du groupe"
    echo "Permissions (en octale) : $group_perm"
    value="$group_perm"
else
    echo "Statut : Others"
    echo "Permissions (en octale) : $other_perm"
    value="$other_perm"
fi

# Save information
save_info "Droits/Permissions (en octale) de $username sur $dir" "$value"
exit 0
############################################################################