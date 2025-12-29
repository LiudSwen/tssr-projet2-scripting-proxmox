#########################################################################
# Script Momy V.2                                                       #
# Jouveaux Nicolas/Paisant Franck/Chicaud Matthias                      #
# 10/12/2025                                                            #
#########################################################################
# --- Fix encodage console/SSH ---
chcp 65001 > $null
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding           = [System.Text.UTF8Encoding]::new($false)
#########################################################################
#                              Variable                                 #
#########################################################################

# Variable OS
$os_type = ""

# Variable user
$target_user = "wilder"

# Variable for Logging
$log_file = "C:\logs\log_evt.log"

# Variable for scripts directory
$local_doc = [environment]::GetFolderPath('MyDocuments')
$project_root = Join-Path $local_doc 'TSSR-1025-P2-G1'
$script_root = Join-Path $project_root 'scripts'

#########################################################################
#                         BASH FUNCTION                                 #
#########################################################################
#-------------------- Execution script ----------------------------------
#Function loggin for navigation in script_momy
function log_event_navigation{
    param (
        [string]$event
    )
$date = Get-Date -Format "yyyyMMdd"
$hour = Get-Date -Format "HHmmss"
$user = $env:USERNAME

Add-Content -Path $log_file -Value "${date}_${hour}_${user}_${event}"
}

# Function loggin for informations
function log_event_information{
    param (
        [string] $event
    )
$date = Get-Date -Format "yyyyMMdd"
$hour = Get-Date -Format "HHmmss"
$user = $env:USERNAME

Add-Content -Path $log_file -Value "${date}_${hour}_${user}_${event}_${target_user}_${target_computer}"
}

# Function loggin for actions
function log_event_action{
    param (
        [string] $event
    )
$date = Get-Date -Format "yyyyMMdd"
$hour = Get-Date -Format "HHmmss"
$user = $env:USERNAME

Add-Content -Path $log_file -Value "${date}_${hour}_${user}_${event}_${target_user}_${target_computer}"
}

# Function loggin for connexion ssh
function log_event_connexion{
    param (
        [string] $event
    )
$date = Get-Date -Format "yyyyMMdd"
$hour = Get-Date -Format "HHmmss"
$user = $env:USERNAME

Add-Content -Path $log_file -Value "${date}_${hour}_${user}_${event}_${target_user}_${target_computer}"
}

#function to run a script with file call
function execution_script_information{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name" -ForegroundColor Yellow
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh -tt "${target_user}@${target_computer}" "bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès" -ForegroundColor Blue
                                Write-Host ""
                                ###########################################################################
                                # Retrieve directory 

                                # Define local directory for storing downloaded info files
                                $local_info_dir = Join-Path $script_root 'info'
                                # Create the local /info directory if it does not exist
                                New-Item -ItemType Directory -Path $local_info_dir -Force | Out-Null
                                # Check if the retrieval was successful
                                scp "${target_user}@${target_computer}:~/Documents/info/*" "$local_info_dir"  | Out-Null
                                    if ($? -eq $true) 
                                    {
                                        Write-Host "Les fichiers info ont été importés dans $local_info_dir" -ForegroundColor Green
                                        Write-Host ""
                                    }    
                                    else 
                                    {
                                        Write-Host "WARNING !!! Aucun fichier info récupéré ou dossier vide." -ForegroundColor Red
                                        Write-Host ""
                                    }
                                ###########################################################################
                                }
                            else 
                            {
                                Write-Host "WARNING !!!  Le $script_name ne s'est pas éxécuté !!!" -ForegroundColor Red
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name" | Out-Null
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer" -ForegroundColor Green
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!!  Le fichier $script_name n'a pas été supprimé de $target_computer" -ForegroundColor Red
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné" -ForegroundColor Red
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#Function to run a script in sudo mode with file call
function execution_script_sudo_information{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name" -ForegroundColor Yellow
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh -tt "${target_user}@${target_computer}" "sudo bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès" -ForegroundColor Blue
                                Write-Host ""
                                ###########################################################################
                                # Retrieve directory 

                                # Define local directory for storing downloaded info files
                                $local_info_dir = Join-Path $script_root 'info'
                                # Create the local /info directory if it does not exist
                                New-Item -ItemType Directory -Path $local_info_dir -Force | Out-Null
                                # Check if the retrieval was successful
                                scp "${target_user}@${target_computer}:~/Documents/info/*" "$local_info_dir" | Out-Null
                                    if ($? -eq $true) 
                                    {
                                        Write-Host "Les fichiers info ont été importés dans $local_info_dir" -ForegroundColor Green
                                        Write-Host ""
                                    }    
                                    else 
                                    {
                                        Write-Host "WARNING !!! Aucun fichier info récupéré ou dossier vide." -ForegroundColor Red
                                        Write-Host ""
                                    }
                                ###########################################################################
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!" -ForegroundColor Red
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer" -ForegroundColor Green
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer" -ForegroundColor Red
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné" -ForegroundColor Red
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#function execution script action
function execution_script_action{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name" -ForegroundColor Yellow
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh -tt "${target_user}@${target_computer}" "bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès" -ForegroundColor Blue
                                Write-Host ""
                               
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!" -ForegroundColor Red
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer" -ForegroundColor Green
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer" -ForegroundColor Red
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné" -ForegroundColor Red
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#execution script sudo action
function execution_script_sudo_action{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name" -ForegroundColor Yellow
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh -tt "${target_user}@${target_computer}" "sudo bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès" -ForegroundColor Blue
                                Write-Host ""
                               
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!" -ForegroundColor Red
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer" -ForegroundColor Green
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer" -ForegroundColor Red
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné" -ForegroundColor Red
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

log_event_information "InformationRechercheEvenementLog_Event.LogOrdinateur"
# Display the main menu
function menu {
    Clear-Host
    while ($true) {
        Show-Machine "$target_computer"
        Write-Host "Menu :" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1) Utilisateur"
        Write-Host "2) Ordinateur"
        Write-Host "3) Recherche des évènements dans le fichier log_evt.log pour un utilisateur"
        Write-Host "4) Recherche des évènements dans le fichier log_evt.log pour un ordinateur"
        Write-Host "5) Prise en main à distance (CLI)"
        Write-Host "6) Exécution de script sur la machine distante"
        Write-Host "7) Changer de machine"
        Write-Host "8) Sortie"
        Write-Host ""
        $choice = Read-Host "Votre choix"
    
# User choice for main menu        
        switch ($choice) {
            1 { 
                log_event_navigation "MenuUtilisateur"
                menu_user 
            }
            2 { 
                log_event_navigation "MenuOrdinateur"
                menu_desktop 
            }
            3 { 
                log_event_navigation "RechercheEvenement"
                    & ".\script_event_search_by_user.ps1"
                    Read-Host "Appuyer sur ENTER pour revenir au menu"
                menu 
            }
            4 { 
                log_event_navigation "RechercheEvenement"
                    & ".\script_event_search_by_computer.ps1"
                    Read-Host "Appuyer sur ENTER pour revenir au menu"
                menu 
            }
            5 { 
                log_event_navigation "ActionPriseenMainaDistance"
                    & ".\script_remote_control.ps1"
                    Read-Host "Appuyer sur ENTER pour revenir au menu"
                menu 
            }
            6 { 
                log_event_navigation "ActionExecutionScriptaDistance"
                    & ".\script_remote_script_execution.ps1"
                    Read-Host "Appuyer sur ENTER pour revenir au menu"
                menu 
            }
            7 { 
                log_event_navigation "ChangementMachine"
                return
            }
            8 {
                Write-Host "Exit - FIN DE SCRIPT" -ForegroundColor Red
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur" -ForegroundColor Red
                log_event_navigation "ErreurNavigation"
            }
        }
    }
}
# Display the user menu
function menu_user {
    Clear-Host
    while ($true) {
        Show-Machine "$target_computer"
        Write-Host "Menu utilisateur :" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1) Action"
        Write-Host "2) Information"
        Write-Host "3) Retour"
        Write-Host "4) Exit"
        Write-Host ""
        $choice2 = Read-Host "Votre choix"


# User choice for user menu
        switch ($choice2) { 
            1 { 
                log_event_navigation "MenuActionOrdinateur"
                menu_user_action 
            }
            2 { 
                log_event_navigation "MenuInformationOrdinateur"
                menu_user_information 
            }
            3 { 
                Clear-Host
                log_event_navigation "RetourMenuPrincipal"
                return
            }
            4 { 
                Write-Host "Exit - FIN DE SCRIPT" -ForegroundColor Red
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur" -ForegroundColor Red
                log_event_navigation "ErreurNavigation" 
             }
        }
    }
}

# Display the desktop menu
function menu_desktop {
    Clear-Host
    while ($true) {
        Show-Machine "$target_computer"
        Write-Host "Menu ordinateur :" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1) Action"
        Write-Host "2) Information"
        Write-Host "3) Retour"
        Write-Host "4) Exit"
        Write-Host ""
        $choice2 = Read-Host "Votre choix"

# User choice for desktop menu
        switch ($choice2) {
            1 { 
                log_event_navigation "MenuActionUtilisateur"
                menu_desktop_action 
            }
            2 { 
                log_event_navigation "MenuInformationUtilisateur"
                menu_desktop_information 
            }
            3 { 
                Clear-Host
                log_event_navigation "RetourMenuPrincipal"
                return
            }
            4 { 
                Write-Host "Exit - FIN DE SCRIPT" -ForegroundColor Red
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur" -ForegroundColor Red
                log_event_navigation "ErreurNavigation"
            }
        }
    }
}

# Display the user action menu
function menu_user_action {
    Clear-Host
    while ($true) {
        Show-Machine "$target_computer"
        Write-Host "Menu action utilisateur :" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1) Création de compte utilisateur local"
        Write-Host "2) Changement de mot de passe"
        Write-Host "3) Suppression de compte utilisateur local"
        Write-Host "4) Ajout à un groupe d'administration"
        Write-Host "5) Ajout à un groupe"
        Write-Host "6) Modification de permission sur un répertoire"
        Write-Host "7) Retour"
        Write-Host "8) Exit"
        Write-Host ""
        $choice3 = Read-Host "Votre choix"

# User choice for user action menu

        switch ($choice3) {
            1 { 
                Clear-Host
                log_event_information "ActionCreationCompteUtilisateur"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_creating_local_user.sh"
                }    
                else
                {
                    execution_script_windows_action "script_creating_local_user.ps1"
                }
             }
            2 { 
                Clear-Host
                log_event_information "ActionChangementMDP"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_change_password.sh"
                }    
                else
                {
                    execution_script_windows_action "script_change_password.ps1"
                }
             }
            3 { 
                Clear-Host
                log_event_information "ActionSuppressionCompteUtilisateur"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_delete_local_user.sh"
                }    
                else
                {
                    execution_script_windows_action "script_delete_local_user.ps1"
                }
             }
            4 { 
                Clear-Host
                log_event_information "ActionAjoutGroupeAdministration"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_add_group_administration.sh"
                }    
                else
                {
                    execution_script_windows_action "script_add_group_administration.ps1"
                }
             }
            5 { 
                Clear-Host
                log_event_information "ActionAjoutGroupe"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_add_usergroup.sh"
                }    
                else
                {
                    execution_script_windows_action "script_add_usergroup.ps1"
                }  
             }
            6 { 
                Clear-Host
                log_event_information "ActionModificationPermission"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_add_permissions.sh"
                }    
                else
                {
                    execution_script_windows_action "script_add_permissions.ps1"
                }  
            }
            7 { 
                Clear-Host
                log_event_navigation "RetourMenuOrdinateur"
                return
            }
            8 { 
                Clear-Host
                Write-Host "Exit - FIN DE SCRIPT" -ForegroundColor Red
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur" -ForegroundColor Red
                log_event_navigation "ErreurNavigation"
            }
        }
    } 
}

# Display the user information menu
function menu_user_information {
    Clear-Host
    while ($true) {
        Show-Machine "$target_computer"
        Write-Host "Menu information utilisateur :" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1) Droits/permissions de l'utilisateur sur un dossier"
        Write-Host "2) Retour"
        Write-Host "3) Exit"
        Write-Host ""
        $choice3 = Read-Host "Votre choix"


# User choice for user information menu
        switch ($choice3) {
            1 { 
                Clear-Host
                log_event_information "InformationDroitPermissionDossier"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_show_directory_permissions.sh"
                }    
                else
                {
                    execution_script_windows_action "script_show_directory_permissions.ps1"
                }
             }
            2 { 
                Clear-Host
                log_event_navigation "RetourMenuOrdinateur"
                return
            }
            3 { 
                Clear-Host
                Write-Host "Exit - FIN DE SCRIPT" -ForegroundColor Red
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                 Write-Host "Erreur" -ForegroundColor Red
                log_event_navigation "ErreurNavigation"
            }
        }
    }
}

# Display the desktop action menu
function menu_desktop_action {
    Clear-Host
        while ($true) {
        Show-Machine "$target_computer"
        Write-Host "Menu action ordinateur :" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1) Verrouillage"
        Write-Host "2) Redémarrage"
        Write-Host "3) Activation du pare-feu"
        Write-Host "4) Création de répertoire"
        Write-Host "5) Suppression de répertoire"
        Write-Host "6) Retour"
        Write-Host "7) Exit"
        Write-Host ""
        $choice3 = Read-Host "Votre choix"

# User choice for desktop action menu
        switch ($choice3) {
            1 { 
                Clear-Host
                        log_event_information "ActionVerrouillageSession"
                        if ($os_type -eq "linux")
                        {
                            execution_script_action "script_lock.sh"
                        }    
                        else
                        {
                            execution_script_windows_action "script_lock.ps1"
                        }
                    }
            2 { 
                Clear-Host
                        log_event_information "ActionRedemarrage"
                        if ($os_type -eq "linux")
                        {
                            execution_script_sudo_action "script_restart.sh"
                        }    
                        else
                        {
                            execution_script_windows_action "script_restart.ps1"
                        }
            }
            3 { 
                Clear-Host
                        log_event_information "ActionActivationFirewall"
                        if ($os_type -eq "linux")
                        {
                            execution_script_sudo_action "script_firewall.sh"
                        }    
                        else
                        {
                            execution_script_windows_action "script_firewall.ps1"
                        }
            }
            4 { 
                Clear-Host
                        log_event_information "ActionCreationRepertoire"
                        if ($os_type -eq "linux")
                        {
                            execution_script_sudo_action "script_create_directory.sh"
                        }    
                        else
                        {
                            execution_script_windows_action "script_create_directory.ps1"
                        }
            }
            5 { 
                Clear-Host
                        log_event_information "ActionSuppressionRepertoire"
                        if ($os_type -eq "linux")
                        {
                            execution_script_sudo_action "script_suppression_directory.sh"
                        }    
                        else
                        {
                            execution_script_windows_action "script_suppression_directory.ps1"
                        }
            }
            6 { 
                 Clear-Host
                    log_event_navigation "RetourMenuOrdinateur"
                    return
            }
            7 { 
                Clear-Host
                    Write-Host "Exit - FIN DE SCRIPT" -ForegroundColor Red
                    log_event_navigation "EndScript"
                    exit 0
            }
            default 
            { 
                Write-Host "Erreur" -ForegroundColor Red
                    log_event_navigation "ErreurNavigation"
            }
        }
    }
}

# Display the desktop information menu
function menu_desktop_information {
    Clear-Host
        while ($true) {
            Show-Machine "$target_computer"
            Write-Host "Menu information ordinateur :" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "1) Adresse IP, masque de sous-réseau et passerelle"
            Write-Host "2) Version de l'OS"
            Write-Host "3) Carte graphique"
            Write-Host "4) CPU % d'utilisation"
            Write-Host "5) Température du CPU"
            Write-Host "6) Uptime"
            Write-Host "7) Nombre de disques"
            Write-Host "8) Espace disque restant par partition/volume"
            Write-Host "9) Partitions (nombre, nom, FS, taille par disque)"
            Write-Host "10) Liste des utilisateurs locaux"
            Write-Host "11) 5 derniers logins"
            Write-Host "12) 10 derniers évènements critiques" 
            Write-Host "13) Retour"
            Write-Host "14) Exit"
            Write-Host ""
            $choice3 = Read-Host "Votre choix"

# User choice for desktop information menu
            switch ($choice3) {
                1 { 
                    Clear-Host
                        log_event_information "InformationIP"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_ip_adress.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_ip_adress.ps1"
                        }
                    }
                2 { 
                    Clear-Host
                        log_event_information "InformationVersionOs"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_version_os.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_version_os.ps1"
                        }
                }
                3 { 
                    Clear-Host
                        log_event_information "InformationCarteGraphique"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_graphic_card.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_graphic_card.ps1"
                        }
                }
                4 { 
                    Clear-Host
                        log_event_information "InformationPourcentageCPU"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_percent_cpu.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_percent_cpu.ps1"
                        }
                }
                5 {
                    Clear-Host
                        log_event_information "InformationTempératureCpu"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_temp_cpu.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_temp_cpu.ps1"
                        }
                 }
                6 { 
                    Clear-Host
                        log_event_information "InformationTempsUtilisateurOrdinateur"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_uptime.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_uptime.ps1"
                        }
                 }
                7 { 
                    Clear-Host
                        log_event_information "InformationNombreDisque"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_number_disk.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_number_disk.ps1"
                        }
                 }
                8 { 
                    Clear-Host
                        log_event_information "InformationEspaceDisk"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_space_disk.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_space_disk.ps1"
                        }
                }
                9 { 
                    Clear-Host
                        log_event_information "InformationPartitionDisk"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_info_partition.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_info_partition.ps1"
                        }
                }
                10 { 
                    Clear-Host
                        log_event_information "InformationListeUtilisateur"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_local_user_list.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_local_user_list.ps1"
                        }
                }
                11 { 
                    Clear-Host
                        log_event_information "Information5DernierLogin"
                        if ($os_type -eq "linux")
                        {
                            execution_script_information "script_five_last_login.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_five_last_login.ps1"
                        }
                }
                12 { 
                    Clear-Host
                        log_event_information "Information10EvenementCritique"
                        if ($os_type -eq "linux")
                        {
                            execution_script_sudo_information "script_critical_event.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_critical_event.ps1"
                        }
                 }
                13 { 
                    Clear-Host
                    log_event_navigation "RetourMenuOrdinateur"
                    return
                }
                14 { 
                    Clear-Host
                    Write-Host "Exit - FIN DE SCRIPT" -ForegroundColor Red
                    log_event_navigation "EndScript"
                    exit 0
                }
                default 
                { 
                    Write-Host "Erreur" -ForegroundColor Red
                    log_event_navigation "ErreurNavigation" 

                 }
        }
    }
}

#########################################################################
#                       Powershell Functions                            #
#########################################################################

$GREEN = [System.ConsoleColor]::Green
$WHITE = [System.ConsoleColor]::White
$RED = [System.ConsoleColor]::Red
$LABEL = [System.ConsoleColor]::Blue
$NC = [System.ConsoleColor]::Gray
$TITLE = [System.ConsoleColor]::Yellow

# Fonction title server
function Display-Serveur {
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $GREEN
    Write-Host "║                                                                              ║" -ForegroundColor $GREEN
    Write-Host "║                          " -NoNewline -ForegroundColor $GREEN
    Write-Host "  The Scripting Project" -NoNewline -ForegroundColor $WHITE
    Write-Host "                             ║" -ForegroundColor $GREEN
    Write-Host "║                                                                              ║" -ForegroundColor $GREEN
    Write-Host "║                                    " -NoNewline -ForegroundColor $GREEN
    Write-Host "by  " -NoNewline -ForegroundColor $NC
    Write-Host "                                      ║" -ForegroundColor $GREEN
    Write-Host "║                                                                              ║" -ForegroundColor $GREEN
    Write-Host "║                        " -NoNewline -ForegroundColor $GREEN
    Write-Host "Nicolas" -NoNewline -ForegroundColor $LABEL
    Write-Host " / " -NoNewline -ForegroundColor $NC
    Write-Host "Matthias" -NoNewline -ForegroundColor $WHITE
    Write-Host " / " -NoNewline -ForegroundColor $NC
    Write-Host "Franck " -NoNewline -ForegroundColor $RED
    Write-Host "                          ║" -ForegroundColor $GREEN
    Write-Host "║                                                                              ║" -ForegroundColor $GREEN
    Write-Host "║                             " -NoNewline -ForegroundColor $GREEN
    Write-Host "SERVEUR : SVRWIN01" -NoNewline -ForegroundColor $NC
    Write-Host "                               ║" -ForegroundColor $GREEN
    Write-Host "║                                                                              ║" -ForegroundColor $GREEN
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $GREEN
    Write-Host ""
}

# Fonction title machine
function Show-Machine {
    param (
        [string]$machine
    )
    
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $GREEN
    Write-Host "║                                                                              ║" -ForegroundColor $GREEN
    Write-Host "║                         " -NoNewline -ForegroundColor $GREEN
    Write-Host "M A C H I N E " -NoNewline -ForegroundColor $TITLE
    Write-Host " : " -NoNewline -ForegroundColor $NC
    Write-Host "$machine" -NoNewline -ForegroundColor $GREEN
    Write-Host "                            ║" -ForegroundColor $GREEN
    Write-Host "║                                                                              ║" -ForegroundColor $GREEN
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $GREEN
    Write-Host ""
}

##################################Execution Script Windows###############


#function to run a script with file call
function execution_script_windows_information{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name" -ForegroundColor Yellow
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:C:/Users/$target_user/Documents/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh -tt "${target_user}@${target_computer}" "powershell.exe -ExecutionPolicy Bypass -File C:/Users/$target_user/Documents/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès" -ForegroundColor Blue
                                Write-Host ""
                                ###########################################################################
                                # Retrieve directory 

                                # Define local directory for storing downloaded info files
                                $local_info_dir = Join-Path $script_root 'info'
                                # Create the local /info directory if it does not exist
                                New-Item -ItemType Directory -Path $local_info_dir -Force | Out-Null
                                # Check if the retrieval was successful
                                scp "${target_user}@${target_computer}:C:\Users\$target_user\Documents\info\*" "$local_info_dir" | Out-Null
                                    if ($LASTEXITCODE -eq 0) 
                                    {
                                        Write-Host "Les fichiers info ont été importés dans $local_info_dir" -ForegroundColor Green
                                        Write-Host ""
                                    }    
                                    else 
                                    {
                                        Write-Host "WARNING !!!Aucun fichier info récupéré ou dossier vide." -ForegroundColor Red
                                        Write-Host ""
                                    }
                                ###########################################################################
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!" -ForegroundColor Red
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/$script_name -Force"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer" -ForegroundColor Green
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host " WARNING !!!  Le fichier $script_name n'a pas été supprimé de $target_computer" -ForegroundColor Red
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné" -ForegroundColor Red
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#execution script PowerShell action
function execution_script_windows_action{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name" -ForegroundColor Yellow
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:C:/Users/$target_user/Documents/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh -tt "${target_user}@${target_computer}" "powershell.exe -ExecutionPolicy Bypass -File C:/Users/$target_user/Documents/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès" -ForegroundColor Blue
                                Write-Host ""
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!" -ForegroundColor Red
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/$script_name -Force" | Out-Null
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer" -ForegroundColor Green
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer" -ForegroundColor Red
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné" -ForegroundColor Red
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }
#########################################################################

#########################################################################
#                               Script                                  #
#########################################################################
# Creation file log_evt.log and give right 666 (read and write for all)
if (-Not (Test-Path "C:\logs\log_evt.log"))
{
    Clear-Host
    Write-Host "Création du fichier de journalisation"
    New-Item -Path "C:\logs" -ItemType Directory -Force | Out-Null
    New-Item -Path "C:\logs\log_evt.log" -ItemType File -Force | Out-Null
}

log_event_navigation "StartScript"
#Principal Boucle
while ($true)
{

    # Ask for the desired computer
    while ($true)
    {
        Clear-Host
        Display-Serveur
        Write-Host "Sur quel Poste Client voulez-vous vous connecter ?" -ForegroundColor Yellow
        Write-Host "Format accepté : Nom complet ou adresse IP" -ForegroundColor Green
        Write-Host ""
        # ask target and save un variable
        $target_computer = Read-Host "Le Poste Client demandé"

        # Check if the requested computer exists in the SSH connection software
        Clear-Host
        # show hosts et check if user is on
        if (-Not (Get-Content "C:\Windows\System32\drivers\etc\hosts" | Select-String "$target_computer"))
        {
            Write-Host "Le Poste client demandé n'éxiste pas sur notre réseaux veuillez mentionner un PC existant dans notre réseau." -ForegroundColor Red
            Write-Host ""
            log_event_connexion "ERREURPosteClientInconnu"
            Read-Host " Appuyer sur Entréé pour réessayer..."
        }
        else
        {
            break
        }     
    }
    
    #detection version pc
    Clear-Host
    Write-Host "Détection du système d'exploitation en cours..." -ForegroundColor Blue 
    Write-Host ""

    ssh "${target_user}@${target_computer}" "[ -d /etc ]" | Out-Null

    if ($? -eq $true)
    {    
        $os_type="linux"
        Write-Host "Système détecté : Linux" -ForegroundColor Green
    }
    else
    {
        $os_type="windows"
        Write-Host "Système détecté : Windows" -ForegroundColor Green
    }
    Write-Host ""
    Start-Sleep -Seconds 2

    menu
}            

#########################################################################
