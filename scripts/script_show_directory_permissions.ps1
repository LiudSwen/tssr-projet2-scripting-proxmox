#########################################################################
# Script version os
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

    # creation directory if doesn't exist 
   if (-Not (Test-Path $info_dir)) {
        New-Item -Path $info_dir -ItemType Directory -Force | Out-Null
    }
    # save information in file
     "[$time_save_info] $label : $value" | Out-File -FilePath $info_file -Append
}

#########################################################################
# Script
#########################################################################
# menu name display
    Write-Host "Droits/Permissions de l'utilisateur sur un dossier" -ForegroundColor Yellow
    Write-Host ""

# Wich user
    $username=Read-Host "Quel utilisateur ?"
    $dir=Read-Host "Quel dossier (chemin)"

# Verification if user exist
$exist = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
    if ( -not $exist )
    {
        Write-Host "WARNING : l'utilisateur $username n'existe pas." -Foregroundcolor Red
        exit 1
    }
# Verification if directory exist
if (-Not (Test-Path $dir)) {
    Write-Host "WARNING ! Dossier invalide : $dir" -ForegroundColor Red
    exit 1
}

# get ACL for directory
$acl = Get-Acl -Path $dir

# Filter perm by username
$permissions = $acl.Access | Where-Object { $_.IdentityReference -like "*$username*" }

Write-Host "Droits effectifs pour $username" -ForegroundColor Green
Write-Host ""

# Show the result
if ($permissions) {
    # reload variable
    $value = ""
    # Show perm for the user
    foreach ($perm in $permissions) {
        Write-Host "Identite: $($perm.IdentityReference)"
        Write-Host "Acces: $($perm.AccessControlType)"
        Write-Host "Droits: $($perm.FileSystemRights)"
        Write-Host "Herite: $($perm.IsInherited)"
        Write-Host "---"
        
        # save
        $value += "$($perm.IdentityReference) - $($perm.AccessControlType) - $($perm.FileSystemRights); "
    }
    # Save information
    save_info -label "Droits/Permissions de $username sur $dir" -value $value
    
} else {
    Write-Host "Aucune permission trouvée pour: $username" -ForegroundColor Red
    # Save information
    save_info -label "Droits/Permissions de $username sur $dir" -value "Aucune permission trouvée"
}

exit 0

#############################################################################