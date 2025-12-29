#!/bin/bash

#########################################################################
# Script Dady V.12
# script must be executed with "sudo"
# Chicaud Matthias/Paisant Franck
# 04/12/2025
#########################################################################

#########################################################################
#                     Define colors with variables                      #
#########################################################################

# For menu titles: Underlined and yellow
TITLE='\033[1;33m'
# Used for labels: purple
LABEL='\033[1;94m'
# Used for FALSE: red
RED='\033[0;91m'
# Used for TRUE: green
GREEN='\033[0;32m'
# Reset color at end of line
NC='\033[0m'
# White
WHITE='\033[1;97m'

#########################################################################

#########################################################################
#                              Variable                                 #
#########################################################################

# Variable user
target_user=wilder

# Variable for Logging
log_file=/var/log/log_evt.log

# Variable OS
os_type=""

#########################################################################

#########################################################################
#                           Bash Function                               #
#########################################################################

# Fonction title server
display_serveur() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                              ║"
    echo -ne "║                          "
    echo -ne    "  ${WHITE}The Scripting Project${GREEN}    "
    echo "                         ║"
    echo "║                                                                              ║"
    echo -ne "║                                    "
    echo -ne "  ${NC}by${GREEN} "
    echo "                                     ║"
    echo "║                                                                              ║"
    echo -ne "║                        "
    echo -ne " ${LABEL}Nicolas${NC} / ${WHITE}Matthias${NC} / ${RED}Franck${GREEN} "
    echo "                         ║"
    echo "║                                                                              ║"
    echo -ne "║                             "
    echo -ne  "${NC}SERVEUR : SVRLX01${GREEN}  "
    echo "                              ║"
    echo "║                                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

#fonction title
display_machine() {
    local machine="$1"
    
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                              ║"
    echo -ne "║                         "
    echo -ne "${TITLE}M A C H I N E ${NC} : ${GREEN} ${machine}                       "
    echo "    ║"
    echo "║                                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}
#-------------------- Execution script ----------------------------------
# Function loggin for navigation in script_dady
log_event_navigation()
{
    local date="$(date +"%Y%m%d")"
    local hour="$(date +"%H%M%S")"
    local user="$(whoami)"
    local event="$1"
    echo -e ""$date"_"$hour"_"$user"_"$event"" >> "$log_file"
}

# Function loggin for informations
log_event_information()
{
    local date="$(date +"%Y%m%d")"
    local hour="$(date +"%H%M%S")"
    local user="$(whoami)"
    local event="$1"
    echo ""$date"_"$hour"_"$user"_"$event"_"$target_user"_"$target_computer"" >> "$log_file"
}

# Function loggin for actions
log_event_action()
{
    local date="$(date +"%Y%m%d")"
    local hour="$(date +"%H%M%S")"
    local user="$(whoami)"
    local event="$1"
    echo ""$date"_"$hour"_"$user"_"$event"_"$target_user"_"$target_computer"" >> "$log_file"
}

# Function loggin for connexion ssh
log_event_connexion()
{
    local date="$(date +"%Y%m%d")"
    local hour="$(date +"%H%M%S")"
    local user="$(whoami)"
    local event="$1"
    echo ""$date"_"$hour"_"$user"_"$event"_"$target_user"_"$target_computer"" >> "$log_file"
}

#-------------------- Execution script ----------------------------------
#function to run a script with file call
execution_script_information()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_computer et éxécution du $script_name${NC}"
                    scp ~/Documents/TSSR-1025-P2-G1/scripts/"$script_name" "$target_user"@"$target_computer":/tmp/ &> /dev/null
                        if [ $? -eq 0 ]
                        then
                            ssh "$target_user"@"$target_computer" "bash /tmp/"$script_name""
                            if [ $? -eq 0 ]
                            then
                                echo -e "${LABEL}Le $script_name a été exécuté avec succès${NC}"
                                echo ""
                                ###########################################################################
                                # Retrieve directory 

                                # Define local directory for storing downloaded info files
                                local_info_dir="$HOME/Documents/TSSR-1025-P2-G1/scripts/info"
                                # Create the local /info directory if it does not exist
                                mkdir -p "$local_info_dir"
                                # Check if the retrieval was successful
                                scp "$target_user"@"$target_computer":~/Documents/info/* "$local_info_dir"/  &> /dev/null
                                    if [ $? -eq 0 ]
                                    then
                                        echo -e "${GREEN}Les fichiers info ont été importés dans $local_info_dir${NC}"
                                        echo ""
                                    else
                                        echo -e "${RED}WARNING !!!${NC} Aucun fichier info récupéré ou dossier vide."
                                        echo ""
                                    fi
                                ###########################################################################
                            else
                                echo -e "${RED} WARNING !!! ${NC} Le $script_name ne s'est pas éxécuté !!!"
                                echo ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            fi
                            ssh "$target_user"@"$target_computer" "rm /tmp/"$script_name""
                                if [ $? -eq 0 ]
                                then
                                    echo -e "${GREEN}Le fichier $script_name a bien été effacé de $target_computer${NC}"
                                    echo ""
                                else
                                    echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    echo ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                fi
                            #ssh "$target_user"@"$target_computer" "rm -r /tmp/info"
                            #    if [ $? -eq 0 ]
                            #    then
                            #        echo "Le dossier info a bien été effacé de $target_computer"
                            #        echo ""
                            #    else
                            #        echo -e "${RED} WARNING !!! ${NC} Le dossier info n'a pas été supprimé de $target_computer"
                            #        echo ""
                            #        log_event_connexion "ERREURFichierInfoNonSupprimeSortieSSH"
                            #        return 1
                            #    fi
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        fi  
    }
#Function to run a script in sudo mode with file call
execution_script_sudo_information()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_computer et éxécution du $script_name${NC}"
                    scp ~/Documents/TSSR-1025-P2-G1/scripts/"$script_name" "$target_user"@"$target_computer":/tmp/ &> /dev/null
                        if [ $? -eq 0 ]
                        then
                            ssh -t "$target_user"@"$target_computer" "sudo bash /tmp/"$script_name""
                            if [ $? -eq 0 ]
                            then
                                echo -e "${LABEL}Le $script_name a été exécuté avec succès${NC}"
                                echo ""
                                ###########################################################################
                                # Retrieve directory 

                                # Define local directory for storing downloaded info files
                                local_info_dir="$HOME/Documents/TSSR-1025-P2-G1/scripts/info"
                                # Create the local /info directory if it does not exist
                                mkdir -p "$local_info_dir"
                                # Check if the retrieval was successful
                                scp "$target_user"@"$target_computer":~/Documents/info/* "$local_info_dir"/  &> /dev/null
                                    if [ $? -eq 0 ]
                                    then
                                        echo -e "${GREEN}Les fichiers info ont été importés dans $local_info_dir${NC}"
                                        echo ""
                                    else
                                        echo -e "${RED}WARNING !!!${NC} Aucun fichier info récupéré ou dossier vide."
                                        echo ""
                                    fi
                                 ###########################################################################
                            else
                                echo -e "${RED} WARNING !!! ${NC} Le $script_name ne s'est pas éxécuté !!!"
                                echo ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            fi
                            ssh "$target_user"@"$target_computer" "rm /tmp/"$script_name""
                                if [ $? -eq 0 ]
                                then
                                    echo -e "${GREEN}Le fichier $script_name a bien été effacé de $target_computer${NC}"
                                    echo ""
                                else
                                    echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    echo ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                fi
                            #ssh "$target_user"@"$target_computer" "rm -r /tmp/info"
                            #    if [ $? -eq 0 ]
                            #    then
                            #        echo "Le dossier info a bien été effacé de $target_computer"
                            #        echo ""
                            #    else
                            #        echo -e "${RED} WARNING !!! ${NC} Le dossier info n'a pas été supprimé de $target_computer"
                            #        echo ""
                            #        log_event_connexion "ERREURFichierInfoNonSupprimeSortieSSH"
                            #        return 1
                            #    fi
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        fi  
    }

#function execution script action
 execution_script_action()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_computer et éxécution du $script_name${NC}"
                    scp ~/Documents/TSSR-1025-P2-G1/scripts/"$script_name" "$target_user"@"$target_computer":/tmp/ &> /dev/null
                        if [ $? -eq 0 ]
                        then
                            ssh "$target_user"@"$target_computer" "bash /tmp/"$script_name""
                            if [ $? -eq 0 ]
                            then
                                echo -e "${LABEL}Le $script_name a été exécuté avec succès${NC}"
                                echo ""
                            else
                                echo -e "${RED} WARNING !!! ${NC} Le $script_name ne s'est pas éxécuté !!!"
                                echo ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            fi
                            ssh "$target_user"@"$target_computer" "rm /tmp/"$script_name""
                                if [ $? -eq 0 ]
                                then
                                    echo -e "${GREEN} Le fichier $script_name a bien été effacé de $target_computer${NC}"
                                    echo ""
                                else
                                    echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    echo ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    exit 1
                                fi
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        fi  
    }   
#execution script sudo action
 execution_script_sudo_action()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_computer et éxécution du $script_name${NC}"
                    scp ~/Documents/TSSR-1025-P2-G1/scripts/"$script_name" "$target_user"@"$target_computer":/tmp/ &> /dev/null
                        if [ $? -eq 0 ]
                        then
                            ssh -t "$target_user"@"$target_computer" "sudo bash /tmp/"$script_name""
                            if [ $? -eq 0 ]
                            then
                                echo -e "${LABEL}Le $script_name a été exécuté avec succès${NC}"
                                echo ""
                            else
                                echo -e "${RED} WARNING !!! ${NC} Le $script_name ne s'est pas éxécuté !!!"
                                echo ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                exit 1
                            fi
                            ssh "$target_user"@"$target_computer" "rm /tmp/"$script_name""
                                if [ $? -eq 0 ]
                                then
                                    echo -e "${GREEN}Le fichier $script_name a bien été effacé de $target_computer${NC}"
                                    echo ""
                                else
                                    echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    echo ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    exit 1
                                fi
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            exit 1
                        fi  
    }   
# ---------------------- Menu function -----------------------------
# Main menu, which calls the main User and Computer menus
menu()
    {
    while true; do
        clear
        display_machine "$target_computer"
        echo -e "${TITLE}Menu :${NC}"
        echo ""
        echo -e "${GREEN}1)${NC} Utilisateur (Action/Information)"
        echo -e "${GREEN}2)${NC} Ordinateur  (Action/Information)"
        echo -e "${GREEN}3)${NC} Recherche des evenements dans le fichier log_evt.log pour un utilisateur"
        echo -e "${GREEN}4)${NC} Recherche des évènements dans le fichier log_evt.log pour un ordinateur"
        echo -e "${GREEN}5)${NC} Prise en main à distance (CLI)"
        echo -e "${GREEN}6)${NC} Exécution de script sur la machine distante"
        echo -e "${GREEN}7)${NC} Changer de machine"
        echo -e "${GREEN}8)${NC} Sortie"
        echo ""
        read -p "Votre choix :" choice

        case $choice in
            1)  log_event_navigation "MenuUtilisateur"
                    menu_user
                ;; 
            2)  log_event_navigation "MenuOrdinateur"
                    menu_computer
                ;;
            3)  log_event_navigation "RechercheDesEvenements"
                    bash script_event_search_by_user.sh
                    read -p "${LABEL}Appuyer sur ENTER pour revenir au menu${NC}"
                    menu
                ;;
            4)  log_event_navigation "InformationRechercheEvenementLog_Event.logOrdinateur"
                    bash script_event_search_by_computer.sh
                    read -p "${LABEL}Appuyer sur ENTER pour revenir au menu${NC}"
                    menu
                ;;
            5)  log_event_navigation "ActionPriseaDistance"
                    bash script_remote_control.sh
                    read -p "${LABEL}Appuyer sur ENTER pour revenir au menu${NC}"
                    menu
                ;;
            6)  log_event_navigation "ActionExecutionScript"
                    bash script_remote_script_execution.sh
                    echo -e "${LABEL}Appuyer sur ENTER pour revenir au menu${NC}"
                    menu
                ;;
            7)  log_event_navigation "ChangementMachine"
                    return
                ;; 
            8)  echo -e "${RED}Exit - FIN DE SCRIPT${NC}"
                    log_event_navigation "EndScript"
                    exit 0
                ;;
            *)  echo -e "${RED}Erreur${NC}"
                    log_event_navigation "ErreurNavigation"
                ;;
        esac
    done
    }

## User menu, which calls the Action and Information menus for the user
menu_user()
    {
        clear
        while true; do
            display_machine "$target_computer"
            echo -e "${TITLE}Menu utilisateur:${NC}"
            echo ""
            echo -e "${GREEN}1)${NC} Action"
            echo -e "${GREEN}2)${NC} Information"
            echo -e "${GREEN}3)${NC} Retour"
            echo -e "${GREEN}4)${NC} Exit"
            echo ""
            read -p "Votre choix :" choice2

            case $choice2 in
                1)  log_event_navigation "MenuActionUtilisateur"
                        menu_user_action
                    ;;
                2)  log_event_navigation "MenuInformationUtilisateur"
                        menu_user_information
                    ;;
                3)  clear
                        echo -e "Retour"
                        log_event_navigation "RetourMenuPrincipal"
                        break
                    ;;
                4)  echo -e "${RED}Exit - FIN DE SCRIPT${NC}"
                        log_event_navigation "EndScript"
                        exit 0
                    ;;
                *)  echo -e "${RED}ERREUR${NC}"
                        log_event_navigation "ErreurNavigation"
                    ;;
            esac
        done
    }

### User action menu, which calls the Actions for the user
menu_user_action()
    {
    clear
        while true; do
            display_machine "$target_computer"
            echo -e "${TITLE}Menu action utilisateur:${NC}"
            echo ""
            echo -e "${GREEN}1)${NC} Création de compte utilisateur local"
            echo -e "${GREEN}2)${NC} Changement de mot de passe"
            echo -e "${GREEN}3)${NC} Suppression de compte utilisateur local"
            echo -e "${GREEN}4)${NC} Ajout à un groupe d'administration"
            echo -e "${GREEN}5)${NC} Ajout à un groupe"
            echo -e "${GREEN}6)${NC} Modification de permission sur un répertoire"                
            echo -e "${GREEN}7)${NC} Retour"
            echo -e "${GREEN}8)${NC} Exit"
            echo ""
            read -p "Votre choix :" choice3

            case $choice3 in
                1)  clear
                        log_event_action "ActionCreationCompteUtilisateur"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_creating_local_user.sh"
                        else
                            execution_script_windows_action "script_creating_local_user.ps1"
                        fi
                    ;;
                2)  clear
                        log_event_action "ActionChangementMDP"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_change_password.sh"
                        else
                            execution_script_windows_action "script_change_password.ps1"
                        fi
                    ;;
                3)  clear
                        log_event_action "ActionSuppressionCompteUtilisateur"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_delete_local_user.sh"
                        else
                            execution_script_windows_action "script_delete_local_user.ps1"
                        fi
                    ;;
                4)  clear
                        log_event_action "ActionAjoutGroupeAdministration"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_add_group_administration.sh"
                        else
                            execution_script_windows_action "script_add_group_administration.ps1"
                        fi
                    ;;
                5)  clear
                        log_event_action "ActionAjoutGroupe"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_add_usergroup.sh"
                        else
                            execution_script_windows_action "script_add_usergroup.ps1"
                        fi
                    ;;
                6)  clear
                        log_event_action "ActionModificationPermission"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_add_permissions.sh"
                        else
                            execution_script_windows_action "script_add_permissions.ps1"
                        fi
                    ;;
                7)  clear
                        log_event_navigation "RetourMenuUtilisateur"
                        break
                    ;;
                8)  echo -e "${RED}Exit - FIN DE SCRIPT${NC}"
                        log_event_navigation "EndScript"
                        exit 0
                    ;;
                *)  echo -e "${RED}ERREUR${NC}"
                        log_event_navigation "ErreurNavigation"
                    ;;
            esac
        done
    }


### User information menu, which calls the information for the user
menu_user_information()
    {
        clear
        while true; do
            display_machine "$target_computer"
            echo -e "${TITLE}Menu information utilisateur:${NC}"
            echo ""
            echo -e "${GREEN}1)${NC} Droits/permissions de l’utilisateur sur un dossier"
            echo -e "${GREEN}2)${NC} Retour"
            echo -e "${GREEN}3)${NC} Exit"
            echo ""
            read -p "Votre choix :" choice3

            case $choice3 in
                1)  clear
                        log_event_information "InformationDroitPermissionDossier"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_show_directory_permissions.sh"
                        else
                            execution_script_windows_action "script_show_directory_permissions.ps1"
                        fi
                    ;;
                2)  clear
                        log_event_navigation "RetourMenuUtilisateur"
                        break
                    ;;
                3)  echo -e "${RED}Exit - FIN DE SCRIPT${NC}"
                        log_event_navigation "EndScript"
                        exit 0
                    ;;
                *)  echo -e "${RED}ERREUR${NC}"
                        log_event_navigation "ErreurNavigation"
                    ;;
            esac
        done
    }

## Computer menu, which calls the Action and Information menus for the computer
menu_computer()
    {
        clear
        while true; do
            display_machine "$target_computer"
            echo -e "${TITLE}Menu ordinateur:${NC}"
            echo ""
            echo -e "${GREEN}1)${NC} Action"
            echo -e "${GREEN}2)${NC} Information"
            echo -e "${GREEN}3)${NC} Retour"
            echo -e "${GREEN}4)${NC} Exit"
            echo ""
            read -p "Votre choix :" choice2

            case $choice2 in
                1)  log_event_navigation "MenuActionOrdinateur"
                        menu_computer_action
                    ;;
                2)  log_event_navigation "MenuInformationOrdinateur"
                        menu_computer_information
                    ;;
                3)  clear
                        log_event_navigation "RetourMenuPrincipal"
                        break
                    ;;
                4)  echo -e "${RED}Exit - FIN DE SCRIPT${NC}"
                        log_event_navigation "EndScript"
                        exit 0
                    ;;
                *)  echo -e "${RED}ERREUR${NC}"
                        log_event_navigation "ErreurNavigation"
                    ;;
            esac
        done
    }

### Computer action menu, which calls the actions for the computer
menu_computer_action()
    {
        clear
        while true; do
            display_machine "$target_computer"       
            echo -e "${TITLE}Menu action ordinateur:${NC}"
            echo ""
            echo -e "${GREEN}1)${NC} Verrouillage"
            echo -e "${GREEN}2)${NC} Redémarrage"
            echo -e "${GREEN}3)${NC} Activation du pare-feu"
            echo -e "${GREEN}4)${NC} Création de répertoire"
            echo -e "${GREEN}5)${NC} Suppression de répertoire"
            echo -e "${GREEN}6)${NC} Retour"
            echo -e "${GREEN}7)${NC} Exit"
            echo ""
            read -p "Votre choix :" choice3

            case $choice3 in
                1)  clear
                        log_event_action "ActionVerrouillageSession"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_action "script_lock.sh"
                        else
                            execution_script_windows_action "script_lock.ps1"
                        fi
                    ;;
                2)  clear
                        log_event_action "ActionRedemarrage"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_restart.sh"
                        else
                            execution_script_windows_action "script_restart.ps1"
                        fi
                    ;;
                3)  clear
                        log_event_action "ActionActivationFirewall"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_firewall.sh"
                        else
                            execution_script_windows_action "script_firewall.ps1"
                        fi
                    ;;
                4)  clear
                        log_event_action "ActionCreationRepertoire"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_create_directory.sh"
                        else
                            execution_script_windows_action "script_create_directory.ps1"
                        fi
                    ;;
                5)  clear
                        log_event_action "ActionSuppressionRepertoire"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_action "script_suppression_directory.sh"
                        else
                            execution_script_windows_action "script_suppression_directory.ps1"
                        fi
                    ;;
                6)  clear
                        log_event_navigation "RetourMenuOrdinateur"
                        break;;
                7)  clear
                        log_event_navigation "EndScript"
                        echo -e "${RED}Exit - FIN DE SCRIPT${NC}"
                        exit 0;;
                *)  echo -e "${RED}ERREUR${NC}"
                        log_event_navigation "ErreurNavigation";;
            esac
        done
    }

### Computer information menu, which calls the information for the computer
menu_computer_information()
    {
        clear
        while true; do
            display_machine "$target_computer"
            echo -e "${TITLE}Menu action ordinateur:${NC}"
            echo ""
            echo -e "${GREEN}1)${NC} Adresse IP, masque, passerelle"
            echo -e "${GREEN}2)${NC} Version de l'OS"
            echo -e "${GREEN}3)${NC} Carte graphique"
            echo -e "${GREEN}4)${NC} CPU %"
            echo -e "${GREEN}5)${NC} Uptime"
            echo -e "${GREEN}6)${NC} Température CPU"
            echo -e "${GREEN}7)${NC} Nombre de disque"
            echo -e "${GREEN}8)${NC} Partition (nombre, nom, FS, taille) par disque"
            echo -e "${GREEN}9)${NC} Espace disque restant par partition/volume"
            echo -e "${GREEN}10)${NC} Liste des utilisateurs locaux"
            echo -e "${GREEN}11)${NC} 5 derniers logins"
            echo -e "${GREEN}12)${NC} 10 derniers évènements critiques"
            echo -e "${GREEN}13)${NC} Retour"
            echo -e "${GREEN}14)${NC} Exit"
            echo ""
            read -p "Votre choix :" choice3

            case $choice3 in
                1)  clear
                        log_event_information "InformationIP"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_ip_adress.sh"
                        else
                            execution_script_windows_information "script_ip_adress.ps1"
                        fi
                    ;;
                2)  clear
                        log_event_information "InformationVersionOs"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_version_os.sh"
                        else
                            execution_script_windows_information "script_version_os.ps1"
                        fi
                    ;;
                3)  clear
                        log_event_information "InformationCarteGraphique"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_information "script_graphic_card.sh"
                        else
                            execution_script_windows_information "script_graphic_card.ps1"
                        fi
                    ;;
                4)  clear
                        log_event_information "InformationPoucentageCPU"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_percent_cpu.sh"
                        else
                            execution_script_windows_information "script_percent_cpu.ps1"
                        fi
                    ;;
                5)  clear
                        log_event_information "InformationTempsUtilisationOrdinateur"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_uptime.sh"
                        else
                            execution_script_windows_information "script_uptime.ps1"
                        fi
                    ;;
                6)  clear
                        log_event_information "InformationTempsCPU"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_temp_cpu.sh"
                        else
                            execution_script_windows_information "script_temp_cpu.ps1"
                        fi
                    ;;
                7)  clear
                        log_event_information "InformationNombreDisque"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_number_disk.sh"
                        else
                            execution_script_windows_information "script_number_disk.ps1"
                        fi
                    ;;
                8)  clear
                        log_event_information "InformationPartitionDisque"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_info_partition.sh"
                        else
                            execution_script_windows_information "script_info_partition.ps1"
                        fi
                    ;;
                9)  clear
                        log_event_information "InformationEspaceDisque"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_space_disk.sh"
                        else
                            execution_script_windows_information "script_space_disk.ps1"
                        fi
                    ;;
                10) clear 
                        log_event_information "InformationListeUtilisateur"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_local_user_list.sh"
                        else
                            execution_script_windows_information "script_local_user_list.ps1"
                        fi
                    ;;
                11) clear 
                        log_event_information "Information5DernierLogin"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_information "script_five_last_login.sh"
                        else
                            execution_script_windows_information "script_five_last_login.ps1"
                        fi
                    ;;
                12) clear 
                        log_event_information "Information10EvenementCritique"
                        if [ "$os_type" = "linux" ]
                        then
                            execution_script_sudo_information "script_critical_event.sh"
                        else
                            execution_script_windows_information "script_critical_event.ps1"
                        fi
                    ;;
                13) clear
                        log_event_navigation "RetourMenuOrdinateur"
                    break;;
                14) echo -e "${RED}Exit - FIN DE SCRIPT${NC}"
                        log_event_navigation "EndScript"
                        exit 0
                    ;;
                *)  echo -e "${RED}ERREUR${NC}";;
            esac
        done
    }

#########################################################################

#########################################################################
#                       Powershell Functions                            #
#########################################################################

##################################Execution Script Windows###############

execution_script_windows_information()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_computer et éxécution du $script_name${NC}"
                    scp ~/Documents/TSSR-1025-P2-G1/scripts/"$script_name" "$target_user"@"$target_computer":C:/Users/$target_user/Documents/ &> /dev/null
                    echo ""
                        if [ $? -eq 0 ]
                        then
                            ssh  "$target_user"@"$target_computer" "powershell.exe -ExecutionPolicy Bypass -File C:/Users/$target_user/Documents/$script_name"
                            echo ""
                            if [ $? -eq 0 ]
                            then
                                echo -e "${LABEL}Le $script_name a été exécuté avec succès${NC}"
                                echo ""
                                ###########################################################################
                                # Retrieve directory 

                                # Define local directory for storing downloaded info files
                                local_info_dir="$HOME/Documents/TSSR-1025-P2-G1/scripts/info"
                                # Create the local /info directory if it does not exist
                                mkdir -p "$local_info_dir"
                                # Check if the retrieval was successful
                                scp "$target_user"@"$target_computer":C:/Users/$target_user/Documents/info/* "$local_info_dir"/  &> /dev/null
                                    if [ $? -eq 0 ]
                                    then
                                        echo -e "${GREEN}Les fichiers info ont été importés dans $local_info_dir${NC}"
                                        echo ""
                                    else
                                        echo -e "${RED}WARNING !!!${NC} Aucun fichier info récupéré ou dossier vide."
                                        echo ""
                                    fi
                                 ###########################################################################
                            else
                                echo -e "${RED} WARNING !!! ${NC} Le $script_name ne s'est pas éxécuté !!!"
                                echo ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            fi
                            ssh  "$target_user"@"$target_computer" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/$script_name -Force"
                                if [ $? -eq 0 ]
                                then
                                    echo -e "${GREEN}Le fichier $script_name a bien été effacé de $target_computer${NC}"
                                    echo ""
                                else
                                    echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    echo ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                fi
                            #ssh "$target_user"@"$target_computer" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/info -Recurse -Force" 
                            #    if [ $? -eq 0 ]
                            #    then
                            #        echo "Le dossier info a bien été effacé de $target_computer"
                            #        echo ""
                            #    else
                            #        echo -e "${RED} WARNING !!! ${NC} Le dossier info n'a pas été supprimé de $target_computer"
                            #        echo ""
                            #        log_event_connexion "ERREURFichierInfoNonSupprimeSortieSSH"
                            #        return 1
                            #    fi
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                             log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        fi 
    }

#execution script PowerShell action
execution_script_windows_action()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_computer et éxécution du $script_name${NC}"
                    scp ~/Documents/TSSR-1025-P2-G1/scripts/"$script_name" "$target_user"@"$target_computer":C:/Users/$target_user/Documents/ &> /dev/null
                    echo ""
                        if [ $? -eq 0 ]
                        then
                            ssh  "$target_user"@"$target_computer" "powershell.exe -ExecutionPolicy Bypass -File C:/Users/$target_user/Documents/$script_name"
                            echo ""
                            if [ $? -eq 0 ]
                            then
                                echo -e "${LABEL}Le $script_name a été exécuté avec succès${NC}"
                                echo ""
                            else
                                echo -e "${RED} WARNING !!! ${NC} Le $script_name ne s'est pas éxécuté !!!"
                                echo ""
                                log_event_connexion "ERREURScriptNonExecuterSortieSSH"
                                return 1
                            fi
                            ssh  "$target_user"@"$target_computer" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/$script_name -Force"
                                if [ $? -eq 0 ]
                                then
                                    echo -e "${GREEN}Le fichier $script_name a bien été effacé de $target_computer${NC}"
                                    echo ""
                                else
                                    echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    echo ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    return 1
                                fi
                            #ssh "$target_user"@"$target_computer" "powershell.exe -Command Remove-Item C:/Users/$target_user/Documents/$script_name -Force"
                            #    if [ $? -eq 0 ]
                            #    then
                            #        echo "Le fichier $script_name a bien été effacé de $target_computer"
                            #        echo ""
                            #    else
                            #        echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                            #        echo ""
                            #        log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                            #        return 1
                            #    fi
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                             log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        fi  
    }

#########################################################################

#########################################################################
#                               Script                                  #
#########################################################################

# Creation file log_evt.log and give right 666 (read and write for all)
if [ ! -f /var/log/log_evt.log ];
then
    clear
    echo -e "${TITLE}Création du fichier de journalisation${NC}"
    sudo touch /var/log/log_evt.log
    sudo chmod 666 /var/log/log_evt.log
fi

log_event_navigation "StartScript"
#Principal Boucle
while true
do

    # Ask for the desired computer
    while true
    do
        clear
        display_serveur
        echo -e "${TITLE}Sur quel Poste Client voulez-vous vous connecter ?${NC}"
        echo ""
        echo -e "${GREEN}Format accepté : Nom complet ou adresse IP${NC}"
        echo ""
        # ask target and save un variable
        read -p "Le Poste Client demandé :" target_computer

        # Check if the requested computer exists in the SSH connection software
        clear
        # show hosts et check if user is on
        if ! cat /etc/hosts | grep "$target_computer"
        then
            echo -e "${RED}Le Poste client demandé n'éxiste pas sur notre réseaux ${NC} veuillez mentionner un PC existant dans notre réseau."
            echo ""
            log_event_connexion "ERREURPosteClientInconnu"
            read -p " Appuyer sur Entréé pour réessayer..."
        else
            break 
        fi
    done
    #detection version pc
    clear
    echo -e "${LABEL}Détection du système d'exploitation en cours...${NC}"
    echo ""

    if ssh "$target_user"@"$target_computer" "[ -d /etc ]" &> /dev/null
    then
        os_type="linux"
        echo -e "${GREEN} Système détecté : Linux${NC}"
    else
        os_type="windows"
        echo -e "${GREEN} Système détecté : Windows${NC}"
    fi
    echo ""
    sleep 2

    menu
done            

#########################################################################