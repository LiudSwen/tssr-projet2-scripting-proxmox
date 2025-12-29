#########################################################################
# Script event search by user
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

# info_target="wilder" # Uncomment for user script
$info_target = $env:COMPUTERNAME # Uncomment for computer script
$info_date = Get-Date -Format "yyyyMMdd"
$info_dir="C:\Users\$env:USERNAME\Documents\info"
$info_file="$info_dir\info_${info_target}_${info_date}.txt"

# Variable for Logging
$log_file = "C:\logs\log_evt.log"

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
Write-Host "Recherche d'évènement par utilisateur :" -ForegroundColor Yellow
Write-Host ""

# Recherche par utilisateur (3ᵉ champ)
$user = Read-Host "Nom de l'utilisateur"

# verification empty captation
if ([string]::IsNullOrWhiteSpace($user)) 
{
Write-Host "WARNING : Champ texte vide, recommence." -ForegroundColor Red
exit 1
}

$value = Get-Content -Path $log_file -ErrorAction SilentlyContinue | 
Where-Object { $parts = $_ -split '_' 
($parts.Count -ge 5) -and ($parts[4] -eq $user)
}

if ( -not $value )
{
    Write-Host "WARNING ! L'utilisateur n'existe pas sur cette machine." -ForegroundColor Red
}
else
{
    Write-Host "Recherche dans le fichier log_evt.log pour l'utilisateur : $user" -ForegroundColor Yellow
    Start-Sleep 1
    # Get information and select by regex
    $value = Get-Content -Path $log_file | Where-Object { $_ -match [regex]::Escape($user) }

    if ( -not $value )
    {
        Write-Host "WARNING ! Aucun évènement trouvé pour l'utilisateur : $user" -ForegroundColor Red
        Write-Host ""
    }
    else
    {
        Write-Host "Evènements trouvés !" -ForegroundColor Green
        Write-Host "Les événements ont été sauvegardé dans \info_evenements_user.log" -ForegroundColor Green
        Write-Host ""
    }
}    


# save info 
save_info -label "Recherche d'évènement par utilisateur" -value $value

#########################################################################