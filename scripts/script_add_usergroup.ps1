#########################################################################
# Script add user to group
# Jouveaux Nicolas
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

# $info_target = "wilder" # Uncomment for user script
$info_target = $env:COMPUTERNAME # Uncomment for computer script

#########################################################################
# Script
#########################################################################

# Title
Write-Host "Ajout d'un utilisateur à un groupe:" -ForegroundColor Yellow
Write-Host ""

while ($true)
{
    # User to add to group
    $user = Read-Host "Quel est le nom de l'utilisateur à ajouter ?"
    Write-Host ""
    
    # Verify if user exists
    $userExists = Get-LocalUser -Name $user -ErrorAction SilentlyContinue
    if (-not $userExists)
    {
        Write-Host "WARNING !!! L'utilisateur $user n'existe pas" -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    # Which group to add the user to
    $group = Read-Host "A quel groupe voulez-vous ajouter $user ?"
    
    # Verify if the group exists, create it if not
    $groupExists = Get-LocalGroup -Name $group -ErrorAction SilentlyContinue
    Write-Host ""
    if (-not $groupExists)
    
    {
        Write-Host "Le groupe $group n'existe pas." -ForegroundColor Yellow
        Write-Host ""
        $createGroup = Read-Host "Voulez-vous créer ce groupe ? (O/N)"
        
        if ($createGroup -eq "O" -or $createGroup -eq "o")
        {
            try
            {
                New-LocalGroup -Name $group -ErrorAction Stop
                Write-Host "Le groupe $group a été créé avec succès" -ForegroundColor Green
                Write-Host ""
            }
            catch
            {
                Write-Host "WARNING !!! Erreur lors de la création du groupe $group : $($_.Exception.Message)" -ForegroundColor Red
                Write-Host ""
                continue
            }
        }
        else
        {
            Write-Host ""
            continue
        }
    }
    
    # Verify if user is already in the group
    $members = Get-LocalGroupMember -Group $group -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
    if ($members -contains "$env:COMPUTERNAME\$user")
    {
        Write-Host "WARNING !!! $user fait déjà partie du groupe $group" -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    # Verification ok, add user to group
    try
    {
        Add-LocalGroupMember -Group $group -Member $user -ErrorAction Stop
        break
    }
    catch
    {
        Write-Host "WARNING !!! Erreur lors de l'ajout de $user au groupe $group : $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        exit 1
    }
}

# Verify the user has been added to the group
$members = Get-LocalGroupMember -Group $group -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
if ($members -contains "$env:COMPUTERNAME\$user")
{
    Write-Host "$user a bien été ajouté au groupe $group" -ForegroundColor Green
    Write-Host ""
}
else
{
    Write-Host "WARNING !!! $user n'a pas été ajouté au groupe $group" -ForegroundColor Red
    Write-Host ""
    exit 1
}

exit 0
#########################################################################