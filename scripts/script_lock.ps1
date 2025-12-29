#########################################################################
# Script lock
# Chicaud Matthias
# 15/12/2025
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

$countdown = 5

#########################################################################
# Script
#########################################################################

# Title
Write-Host "Compte à rebour avant verrouillage:" -ForegroundColor Yellow
Write-Host ""

while ( $countdown -gt 0 )
{
    Write-Host "$countdown" -ForegroundColor Yellow
    Start-Sleep 1
    $countdown--
}

Write-Host "Verrouillage de l'ordinateur !!"
Start-Sleep 1

tsdiscon 1

exit 0

#########################################################################