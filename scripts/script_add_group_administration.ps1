#########################################################################
# Script create directory
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
Write-Host "Ajout à un groupe d'administration:" -ForegroundColor Yellow
Write-Host ""
while ($true)
{
    # user to add group
    $user = Read-Host "Quel est le nom de l'utilisateur à ajouté"
    
    # verify if user exists
    $userExists = Get-LocalUser -Name $user -ErrorAction SilentlyContinue
    if (-not $userExists)
    {
        Write-Host "WARNING !!! L'utilisateur '$user' n'existe pas !!!" -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    # which group the user is added to
    $group = Read-Host "A quel groupe d'administration voulez-vous ajouté '$user'"
    
    # verification if the group exists
    $groupExists = Get-LocalGroup -Name $group -ErrorAction SilentlyContinue
    if (-not $groupExists)
    {
        Write-Host "WARNING !!! Le groupe d'administration '$group' n'existe pas !!!!!" -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    # verification if user already in the group
    $members = Get-LocalGroupMember -Group $group -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
    if ($members -contains "$env:COMPUTERNAME\$user")
    {
        Write-Host "WARNING !!! '$user' fait déjà partie du groupe '$group'" -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    # verification ok, add user to group
    try
    {
        Add-LocalGroupMember -Group $group -Member $user -ErrorAction Stop
        break
    }
    catch
    {
        Write-Host "WARNING !!! Erreur lors de l'ajout de '$user' au groupe '$group'" -ForegroundColor Red
        Write-Host ""
        exit 1
    }
}

# verification the user has been added to the administration group
$members = Get-LocalGroupMember -Group $group -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
if ($members -contains "$env:COMPUTERNAME\$user")
{
    Write-Host "'$user' a bien été ajouté au groupe d'administration '$group'" -ForegroundColor Green
    Write-Host ""
}
else
{
    Write-Host "WARNING !!! '$user' n'a pas été ajouté au groupe d'administration '$group'" -ForegroundColor Red
    Write-Host ""
}
exit 0
#########################################################################