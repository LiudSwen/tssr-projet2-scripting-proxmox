#########################################################################
# Script create user
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

# $info_target = "wilder" # Uncomment for user script
$info_target = $env:COMPUTERNAME # Uncomment for computer script

#########################################################################
# Script
#########################################################################

# Title
Write-Host "Création compte utilisateur local:" -ForegroundColor Yellow
Write-Host ""

# request for the name .
    $user = Read-Host "Quel est l'utilisateur à créé"

    # verification of .
    $exists = Get-LocalUser -Name $user -ErrorAction SilentlyContinue
    if ( $exists )
    {
        Write-Host "WARNING : L'utilisateur '$user' existe déjà." -Foregroundcolor Red
        exit 1
    }
    try
    {
        New-LocalUser -Name $user -NoPassword -ErrorAction Stop | Out-Null
        Write-Host "L'utilisateur '$user' a été créé" -ForegroundColor Green
        
    }
    catch
    {
        Write-Host "WARNING : L'utilisateur '$user' n'a pas été créé !!!" -ForegroundColor Red
        Write-Host ""
        exit 1
    }
exit 0

#########################################################################