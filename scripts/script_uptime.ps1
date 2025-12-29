#########################################################################
# Script uptime
# Paisant Franck
# 10/12/2025
#########################################################################
# --- Fix encodage console/SSH ---
chcp 65001 > $null
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding           = [System.Text.UTF8Encoding]::new($false)
#########################################################################
# Variable
#########################################################################
# Variable for save_info function

# info_target="wilder" # Uncomment for user script
$info_target = $env:COMPUTERNAME # Uncomment for computer script
$info_date = Get-Date -Format "yyyyMMdd"
$info_dir="C:\Users\$env:USERNAME\Documents\info"
$info_file="$info_dir\info_${info_target}_${info_date}.txt"

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

# menu name display
    Write-Host "Uptime" -ForegroundColor Yellow
    Write-Host ""

# menu command to display Uptime
$uptime = (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime
$value = $uptime | Select-Object Days, Hours, Minutes | Out-String
        Write-Host "$value"
        Write-Host ""

# save info 
save_info -label "Uptime" -value $value

###############################################################################