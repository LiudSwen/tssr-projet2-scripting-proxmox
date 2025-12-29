#########################################################################
# Script firewall
# Jouveaux Nicolas
# 16/12/2025
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

# $info_target = "wilder" # Uncomment for user script
$info_target = $env:COMPUTERNAME # Uncomment for computer script
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

    # Create directory if not exists 
   if (-Not (Test-Path $info_dir)) {
        New-Item -Path $info_dir -ItemType Directory -Force | Out-Null
    }
    # Save information in file
     "[$time_save_info] $label : $value" | Out-File -FilePath $info_file -Append
}

#########################################################################
# Script
#########################################################################

# Title
    Write-Host "Activation du parefeu" -ForegroundColor Yellow
    Write-Host ""

# Display options to enable or disable firewall
    Write-Output "1 - Activer le parefeu"
    Write-Output "2 - Désactiver le parefeu"
    Write-Host ""
    $firewall_choice = Read-Host "Que voulez-vous faire ?"

# Enable or disable firewall based on user choice
    switch ($firewall_choice) {
        "1" {
            Write-Host "Activation du parefeu"
            Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
            Write-Host "Parefeu activé" 
            $firewall_status = "Activé"
        }
        "2" {
            Write-Host "Désactivation du parefeu"
            Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
            Write-Host "Parefeu désactivé" 
            $firewall_status = "Désactivé"
        }  
            Default {
                Write-Host "Choix invalide. Veuillez sélectionner 1 ou 2."
                exit 1
            }
        }
    
    # Save firewall status to info file
        save_info "Firewall Status" $firewall_status
    