#########################################################################
# Script 10 last critical errors
# Chicaud Matthias
# 17/12/2025
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
    Write-Host "10 derniers événements critiques" -ForegroundColor Yellow
    Write-Host ""

# Command to the critical errors


# Result verification
Try
{
    $events = Get-WinEvent -FilterHashtable @{
        LogName='System','Application'
        Level=1
    } -MaxEvents 10 -ErrorAction Stop

    $value = $events | Select-Object TimeCreated, LogName, LevelDisplayName, ProviderName, Message | Out-String
    
    Write-Host ""
    Write-Host "Affichage des 10 derniers événements critiques terminé" -ForegroundColor Green

    # save info 
    save_info -label "10 derniers événements critiques" -value $value
}
catch
{    
    Write-Host ""
    Write-Host "Erreur lors de la récupération des événements critiques" -ForegroundColor Red
    exit 1
}

exit 0

#############################################################################