#########################################################################
# Script info partition
# Paisant Franck
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
    Write-Host "Information des partitions par disques" -ForegroundColor Yellow
    Write-Host ""

# Number partition
$info_partition = Get-Disk | Get-Partition | Select-Object DiskNumber, PartitionNumber, DriveLetter, Size, Type | Format-Table | Out-String
    Write-Host "Voici les informations des partitions sur $info_target :" -ForegroundColor Green
    Write-Host $info_partition -ForegroundColor Green
    Write-Host ""

# save info 
save_info -label "Information des partitions" -value $info_partition

exit 0

#############################################################################
