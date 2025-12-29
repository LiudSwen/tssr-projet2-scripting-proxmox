#########################################################################
# Template save information
# Chicaud Matthias
# 10/12/2025
#########################################################################

#########################################################################
# INFORMATION
#########################################################################
<#
1. Copy the VARIABLE section into your child script.
2. CHOOSE ONE OPTION:
       USER: info_target = "wilder"
       COMPUTER: info_target = $env:COMPUTERNAME
3. Copy the save_info() function into the FUNCTIONS section.
4. Retrieve the information.
5. Format this information into value.
6. Call save_info "Name of information" "$value".

The generated file will be: info_<target>_<yyyymmdd>.txt
Always use >> to add information to the same file for the day.
#>
#########################################################################
# Variable
#########################################################################

# Variable for save_info function

# $info_target = "wilder" # Uncomment for user script
# $info_target = $env:COMPUTERNAME # Uncomment for computer script
$info_date = Get-Date -Format "yyyyMMdd"
$info_dir = "C:\Users\$env:USERNAME\Documents\info"
$info_file = "$info_dir\info_${info_target}_${info_date}.txt"

#########################################################################
# Function
#########################################################################

# Function for save information in file
function save_info {
    param(
        [string]$label,
        [string]$value
    )

    $time_save_info = Get-Date -Format "HH:mm:ss"

    # Création dossier si existe pas 
   if (-Not (Test-Path $info_dir)) {
        New-Item -Path $info_dir -ItemType Directory -Force | Out-Null
    }
    # Sauvegarder information dans le fichier
     "[$time_save_info] $label : $value" | Out-File -FilePath $info_file -Append
}

#########################################################################
# Script
#########################################################################

# Example:
# value="$(lsb_release -ds 2>/dev/null)"
# save_info "Version de l'OS" "$value"

# save info 
$value = "Raw_value"
save_info -label "Version OS" -value $value

#########################################################################