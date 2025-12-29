#########################################################################
# Script Momy V.2                                                       #
# Jouveaux Nicolas/Paisant Franck/Chicaud Matthias                      #
# 10/12/2025                                                            #
#########################################################################

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
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name"
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh "${target_user}@${target_computer}" "bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès"
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
                                        Write-Host "Les fichiers info ont été importés dans $local_info_dir"
                                        Write-Host ""
                                    }    
                                    else 
                                    {
                                        Write-Host "WARNING !!! Aucun fichier info récupéré ou dossier vide."
                                        Write-Host ""
                                    }
                                ###########################################################################
                                }
                            else 
                            {
                                Write-Host "WARNING !!!  Le $script_name ne s'est pas éxécuté !!!"
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name" | Out-Null
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer"
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!!  Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#Function to run a script in sudo mode with file call
function execution_script_sudo_information{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name"
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh "${target_user}@${target_computer}" "sudo bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès"
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
                                        Write-Host "Les fichiers info ont été importés dans $local_info_dir"
                                        Write-Host ""
                                    }    
                                    else 
                                    {
                                        Write-Host "WARNING !!! Aucun fichier info récupéré ou dossier vide."
                                        Write-Host ""
                                    }
                                ###########################################################################
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!"
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer"
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#function execution script action
function execution_script_action{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name"
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh "${target_user}@${target_computer}" "bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès"
                                Write-Host ""
                               
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!"
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer"
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#execution script sudo action
function execution_script_sudo_action{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name"
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:/tmp/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh "${target_user}@${target_computer}" "sudo bash /tmp/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès"
                                Write-Host ""
                               
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!"
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "rm /tmp/$script_name"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer"
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }


# Display the main menu
function menu {
    Clear-Host
    while ($true) {
        Write-Host "Machine : $env:COMPUTERNAME" -ForegroundColor Green
        Write-Host "Menu :" -ForegroundColor Yellow
        Write-Host "1) Utilisateur"
        Write-Host "2) Ordinateur"
        Write-Host "3) Changer de machine"
        Write-Host "4) Sortie"
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
                log_event_navigation "ChangementMachine"
                return
            }
            4 {
                Write-Host "Exit - FIN DE SCRIPT"
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur"
                log_event_navigation "ErreurNavigation"
            }
        }
    }
}
# Display the user menu
function menu_user {
    Clear-Host
    while ($true) {
        Write-Host "Machine : $env:COMPUTERNAME" -ForegroundColor Green
        Write-Host "Menu utilisateur :" -ForegroundColor Yellow
        Write-Host "1) Action"
        Write-Host "2) Information"
        Write-Host "3) Retour"
        Write-Host "4) Exit"
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
                Write-Host "Exit - FIN DE SCRIPT"
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur"
                log_event_navigation "ErreurNavigation" 
             }
        }
    }
}

# Display the desktop menu
function menu_desktop {
    Clear-Host
    while ($true) {
        Write-Host "Machine : $env:COMPUTERNAME" -ForegroundColor Green
        Write-Host "Menu ordinateur :" -ForegroundColor Yellow
        Write-Host "1) Action"
        Write-Host "2) Information"
        Write-Host "3) Retour"
        Write-Host "4) Exit"
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
                Write-Host "Exit - FIN DE SCRIPT"
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur"
                log_event_navigation "ErreurNavigation"
            }
        }
    }
}

# Display the user action menu
function menu_user_action {
    Clear-Host
    while ($true) {
        Write-Host "Machine : $env:COMPUTERNAME" -ForegroundColor Green
        Write-Host "Menu action utilisateur :" -ForegroundColor Yellow
        Write-Host "1) Creation de compte utilisateur local"
        Write-Host "2) Changement de mot de passe"
        Write-Host "3) Suppression de compte utilisateur local"
        Write-Host "4) Ajout a un groupe d'administration"
        Write-Host "5) Ajout a un groupe"
        Write-Host "6) Retour"
        Write-Host "7) Exit"
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
                log_event_navigation "RetourMenuOrdinateur"
                return
            }
            7 { 
                Clear-Host
                Write-Host "Exit - FIN DE SCRIPT"
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                Write-Host "Erreur"
                log_event_navigation "ErreurNavigation"
            }
        }
    } 
}

# Display the user information menu
function menu_user_information {
    Clear-Host
    while ($true) {
        Write-Host "Machine : $env:COMPUTERNAME" -ForegroundColor Green
        Write-Host "Menu information utilisateur :" -ForegroundColor Yellow
        Write-Host "1) Droits/permissions de l'utilisateur sur un dossier"
        Write-Host "2) Recherche des evenements dans le fichier log_evt.log pour un utilisateur"
        Write-Host "3) Retour"
        Write-Host "4) Exit"
        $choice3 = Read-Host "Votre choix"


# User choice for user information menu
        switch ($choice3) {
            1 { 
                Clear-Host
                log_event_information "InformationDroitPermissionDossier"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_add_permissions.sh"
                }    
                else
                {
                    execution_script_windows_action "script_add_permissions.ps1"
                }
             }
            2 { 
                Clear-Host
                log_event_information "InformationRechercheEvenementLog_Evt.logUtilisateur"
                if ($os_type -eq "linux")
                {
                    execution_script_sudo_action "script_event_search_by_user.sh"
                }    
                else
                {
                    execution_script_windows_action "script_event_search_by_user.ps1"
                }
            }
            3 { 
                Clear-Host
                log_event_navigation "RetourMenuOrdinateur"
                return
            }
            4 { 
                Clear-Host
                Write-Host "Exit - FIN DE SCRIPT"
                log_event_navigation "EndScript"
                exit 0
            }
            default 
            { 
                 Write-Host "Erreur"
                log_event_navigation "ErreurNavigation"
            }
        }
    }
}

# Display the desktop action menu
function menu_desktop_action {
    Clear-Host
        while ($true) {
        Write-Host "Machine : $env:COMPUTERNAME" -ForegroundColor Green
        Write-Host "Menu action ordinateur :" -ForegroundColor Yellow
        Write-Host "1) Verrouillage"
        Write-Host "2) Redemarrage"
        Write-Host "3) Activation du pare-feu"
        Write-Host "4) Creation de repertoire"
        Write-Host "5) Suppression de repertoire"
        Write-Host "6) Prise en main à distance (CLI)"
        Write-Host "7) Exécution de script sur la machine distante"
        Write-Host "8) Retour"
        Write-Host "9) Exit"
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
                        log_event_information "ActionPriseEnMainDistance"
                        if ($os_type -eq "linux")
                        {
                            execution_script_action "script_remote_control.sh"
                        }    
                        else
                        {
                            execution_script_windows_action "script_remote_control.ps1"
                        }
            }
            7 { 
                Clear-Host
                        log_event_information "ActionExécutionScriptSurMachineDistante"
                        if ($os_type -eq "linux")
                        {
                            execution_script_action "script_remote_script_execution.sh"
                        }    
                        else
                        {
                            execution_script_windows_action "script_remote_script_execution.ps1"
                        }
            }
            8 { 
                 Clear-Host
                    log_event_navigation "RetourMenuOrdinateur"
                    return
            }
            9 { 
                Clear-Host
                    Write-Host "Exit - FIN DE SCRIPT"
                    log_event_navigation "EndScript"
                    exit 0
            }
            default 
            { 
                Write-Host "Erreur"
                    log_event_navigation "ErreurNavigation"
            }
        }
    }
}

# Display the desktop information menu
function menu_desktop_information {
    Clear-Host
        while ($true) {
            Write-Host "Machine : $env:COMPUTERNAME" -ForegroundColor Green
            Write-Host "Menu information ordinateur :" -ForegroundColor Yellow
            Write-Host "1) Adresse IP, masque de sous-reseau et passerelle"
            Write-Host "2) Version de l'OS"
            Write-Host "3) Carte graphique"
            Write-Host "4) CPU % d'utilisation"
            Write-Host "5) Temperature du CPU"
            Write-Host "6) Uptime"
            Write-Host "7) Nombre de disques"
            Write-Host "8) Espace disque restant par partition/volume"
            Write-Host "9) Partitions (nombre, nom, FS, taille par disque)"
            Write-Host "10) Liste des utilisateurs locaux"
            Write-Host "11) 5 dernierse logins"
            Write-Host "12) 10 derniers evenements critiques"
            Write-Host "13) Recherche des évenements dans le fichier log_evt.log pour un ordinateur"
            Write-Host "14) Retour"
            Write-Host "15) Exit"
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
                        log_event_information "InformationTempsCpu"
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
                        log_event_information "InformationUptime"
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
                            execution_script_information "script_.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_.ps1"
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
                        log_event_information "InformationRechercheEvenementLog_Event.LogOrdinateur"
                        if ($os_type -eq "linux")
                        {
                              execution_script_sudo_information "script_.sh"
                        }    
                        else
                        {
                            execution_script_windows_information "script_.ps1"
                        }
                }
                14 { 
                    Clear-Host
                    log_event_navigation "RetourMenuOrdinateur"
                    return
                }
                15 { 
                    Clear-Host
                    Write-Host "Exit - FIN DE SCRIPT"
                    log_event_navigation "EndScript"
                    exit 0
                }
                default 
                { 
                    Write-Host "Erreur"
                    log_event_navigation "ErreurNavigation" 

                 }
        }
    }
}

#########################################################################
#                       Powershell Functions                            #
#########################################################################

##################################Execution Script Windows###############


#function to run a script with file call
function execution_script_windows_information{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name"
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:C:/Users/$target_user/Documents/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh "${target_user}@${target_computer}" "powershell.exe -ExecutionPolicy Bypass -File C:/Users/$target_user/Documents/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès"
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
                                        Write-Host "Les fichiers info ont été importés dans $local_info_dir"
                                        Write-Host ""
                                    }    
                                    else 
                                    {
                                        Write-Host "WARNING !!!Aucun fichier info récupéré ou dossier vide."
                                        Write-Host ""
                                    }
                                ###########################################################################
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!"
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/$script_name -Force"
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer"
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host " WARNING !!!  Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        }
    }

#execution script PowerShell action
function execution_script_windows_action{
    param (
        [string]$script_name
    )
        
    Write-Host "Connexion à $target_computer et éxécution du $script_name"
                    scp (Join-Path $script_root $script_name) "${target_user}@${target_computer}:C:/Users/$target_user/Documents/" | Out-Null
                        if ( $? -eq $true ) 
                        {        
                            ssh "${target_user}@${target_computer}" "powershell.exe -ExecutionPolicy Bypass -File C:/Users/$target_user/Documents/$script_name"
                            if ( $? -eq $true )
                                {
                                Write-Host "Le $script_name a été exécuté avec succès"
                                Write-Host ""
                                }
                            else 
                            {
                                Write-Host "WARNING !!! Le $script_name ne s'est pas éxécuté !!!"
                                Write-Host ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            }
                            ssh "${target_user}@${target_computer}" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/$script_name -Force" | Out-Null
                                if ($? -eq $true)
                                {
                                    Write-Host "Le fichier $script_name a bien été effacé de $target_computer"
                                    Write-Host ""
                                }
                                else 
                                {
                                    Write-Host "WARNING !!! Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    Write-Host ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                }
                            }    
                        else 
                        {
                            Write-Host "WARNING !!! La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
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
        Write-Host "Sur quel Poste Client voulez-vous vous connecter ?"
        Write-Host "Format accepté : Nom complet ou adresse IP"
        Write-Host ""
        # ask target and save un variable
        $target_computer = Read-Host "Le Poste Client demander"

        # Check if the requested computer exists in the SSH connection software
        Clear-Host
        # show hosts et check if user is on
        if (-Not (Get-Content "C:\Windows\System32\drivers\etc\hosts" | Select-String "$target_computer"))
        {
            Write-Host "Le Poste client demandé n'existe pas sur notre réseaux veuillez mentionner un PC existant dans notre réseau."
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
    Write-Host "Détection du système d'exploitation en cours..."
    Write-Host ""

    ssh "${target_user}@${target_computer}" "[ -d /etc ]" | Out-Null

    if ($? -eq $true)
    {    
        $os_type="linux"
        Write-Host "Système détecté : Linux"
    }
    else
    {
        $os_type="windows"
        Write-Host "Système détecté : Windows"
    }
    Write-Host ""
    Start-Sleep -Seconds 2

    menu
}            

#########################################################################
