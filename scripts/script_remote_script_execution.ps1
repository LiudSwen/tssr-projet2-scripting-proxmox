#!/bin/bash

#########################################################################
# Script remote script execution
# Chicaud Matthias
# 16/12/2025
#########################################################################

#########################################################################
# Variable
#########################################################################

# Arguments passés par le script parent
$target_computer = $args[0]
$target_user     = $args[1]

#########################################################################
# Function
#########################################################################

function execution_script_sudo {

    param (
        [string]$script_path
    )

    # Nom du script sans le chemin
    $script_name = Split-Path $script_path -Leaf
    $remote_path = "C:/Users/$target_user/Documents/$script_name"

    Write-Host "Connexion à $target_user sur la machine $target_computer et exécution de $script_name" -ForegroundColor Yellow

    # 1) Copie du script sur la machine distante
    scp $script_path "${target_user}@${target_computer}:$remote_path"
    if (-not $?) {
        Write-Host "WARNING !!! La copie SCP a échoué" -ForegroundColor Red
        exit 1
    }

    # 2) Exécution du script à distance
    ssh "$target_user@$target_computer" "powershell -ExecutionPolicy Bypass -File $remote_path"
    if (-not $?) {
        Write-Host "WARNING !!! Le script ne s'est pas exécuté" -ForegroundColor Red
        exit 1
    }

    Write-Host "Le script $script_name a été exécuté avec succès" -ForegroundColor Green
    Write-Host ""

    ###########################################################################
    # Retrieve directory

    $local_info_dir = "$PSScriptRoot\info"
    New-Item -ItemType Directory -Path $local_info_dir -Force | Out-Null

    scp -r "$target_user@$target_computer:C:/Users/$target_user/Documents/info/" "$local_info_dir"
    if ($?) {
        Write-Host "Les fichiers info ont été rapatriés dans $local_info_dir"
        Write-Host ""
    }
    else {
        Write-Host "WARNING !!! Aucun fichier info récupéré ou dossier vide" -ForegroundColor Red
        Write-Host ""
    }

    ###########################################################################

    # 3) Suppression du script distant
    ssh "$target_user@$target_computer" "powershell -Command Remove-Item '$remote_path' -Force"
    if ($?) {
        Write-Host "Le fichier $script_name a bien été effacé de $target_computer"
        Write-Host ""
    }
    else {
        Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé" -ForegroundColor Red
        exit 1
    }
}

#########################################################################
# Script
#########################################################################

Clear-Host
Write-Host "Utilisation de script à distance" -ForegroundColor Yellow
Write-Host ""
Write-Host "Quel script voulez-vous utiliser à distance ?" -ForegroundColor Yellow

$script_path = Read-Host "Chemin local vers votre script (.ps1)"

# Vérification que le script existe
if (-not (Test-Path $script_path)) {
    Write-Host "WARNING ! Le script n'existe pas" -ForegroundColor Red
    exit 1
}

Write-Host "Le script existe bien." -ForegroundColor Green
Write-Host ""

execution_script_sudo $script_path
