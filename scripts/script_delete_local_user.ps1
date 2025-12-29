#########################################################################
# Script delete user
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

#########################################################################
# Script
#########################################################################

# Title
Write-Host "Suppression d'utilisateur:" -ForegroundColor Yellow
Write-Host ""

# request for the name of the directory to be deleted.
    $user = Read-Host "Quel est l'utilisateur à supprimé"

    # verification of the directory to be deleted.
    $exists = Get-LocalUser -Name $user -ErrorAction SilentlyContinue
    if ( -not $exists )
    {
        Write-Host "WARNING : l'utilisateur $user n'existe pas." -Foregroundcolor Red
        exit 1
    }
    try
    {
        Remove-LocalUser -Name $user -ErrorAction Stop
        Write-Host "l'utilisateur $user a été supprimé" -ForegroundColor Green
        exit 0
    }
    catch
    {
        Write-Host "WARNING : l'utilisateur "$user" n'a pas été supprimé !!!" -ForegroundColor Red
        Write-Host $_
        exit 1
    }
exit 0

#########################################################################