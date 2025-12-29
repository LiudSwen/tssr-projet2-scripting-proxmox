#########################################################################
# Script de connexion SSH
# Jouveaux Nicolas
# 17/12/2025
#########################################################################

# Title
Write-Host ""
Write-Host "Prise en main en CLI" -ForegroundColor Yellow
Write-Host ""

# Wich user
$user = Read-Host "Quel utilisateur voulez-vous utiliser pour la connexion ?"

# Demander l'adresse du serveur
$remoteHost = Read-Host "Quelle machine voulez-vous joindre ?"

# Afficher les informations
Write-Host ""
Write-Host "Connexion à $user@$remoteHost sur le port $port" -ForegroundColor Green
Write-Host ""

if ([string]::IsNullOrEmpty($portInput)) {
    $port = 22
} else {
    $port = [int]$portInput
}

# Se connecter
if ($port -eq 22) {
    ssh "$user@$remoteHost"
} else {
    ssh -p $port "$user@$remoteHost"
}

# Fin
Write-Host ""
Write-Host "Connexion terminée." -ForegroundColor Green
Write-Host ""

#########################################################################