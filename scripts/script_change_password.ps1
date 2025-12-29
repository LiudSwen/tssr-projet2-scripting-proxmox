#########################################################################
# Script change password
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

#########################################################################
# Function
#########################################################################

#########################################################################
# Script
#########################################################################
# menu name display
    Write-Host "Changement du mot de passe d'un utilisateur" -ForegroundColor Yellow
    Write-Host ""

# User
while ($True) {
    # Input of the user name
    $user = Read-Host "Nom de l'utilisateur dont vous voulez changer le mot de passe"

    # Verify if user exist
    try {
        Get-LocalUser -Name $user -ErrorAction Stop | Out-Null
        Write-Host "Utilisateur trouvé : $user" -ForegroundColor Green
        Write-Host ""
        break
    }
    catch {
        Write-Host "WARNING ! l'utilisateur $user n'existe pas." -ForegroundColor Red
    }
}

Write-Host "Voulez-vous vraiment changer le mot de passe de $user"
$confirm = Read-Host "Confirmez-vous cette action ? (o/n)"

if ($confirm -notmatch '^[oO]$'){
    Write-Host "Opération annulée." -ForegroundColor Red
    exit 0
}

Write-Host ""

# change password
$new_password = Read-Host "Entrez le nouveau mot de passe" -AsSecureString

try {
    Set-LocalUser -Name $user -Password $new_password -ErrorAction Stop
    Write-Host ""
    Write-Host "Le mot de passe de $user a été modifié avec succès !" -ForegroundColor Green
    Write-Host ""
    exit 0
}
catch {
    Write-Host ""
    Write-Host "WARNING ! Une erreur est survenue lors du changement de mot de passe" -ForegroundColor Red
    Write-Host ""
    exit 1
}

#############################################################################