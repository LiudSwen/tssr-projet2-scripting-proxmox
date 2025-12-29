#########################################################################
# Script show ip adress, mask and gateway
# Chicaud Matthias
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

# Title
Write-Host "Adresse IP, masque et passerelle" -ForegroundColor Yellow
Write-Host ""

# Récupérer les infos IPv4 (hors loopback)
$net = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -ne '127.0.0.1'}

$ipaddress = $net.IPAddress
$masque = $net.PrefixLength

# Récupérer la passerelle par défaut
$gateway = (Get-NetRoute -DestinationPrefix '0.0.0.0/0').NextHop

Write-Host "IP      :$ipaddress"
Write-Host "Masque  : $masque"
Write-Host "Passerelle : $gateway"
$value= "IP : $ipaddress / Mask : $masque | Passerelle : $gateway"

# save info 
save_info -label "Adresse IP, masque et passerelle" -value $value

#########################################################################