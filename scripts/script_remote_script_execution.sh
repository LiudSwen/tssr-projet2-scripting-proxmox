#!/bin/bash

#########################################################################
# Script remote script execution
# Chicaud Matthias
# Execution SUDO
# 07/12/2025
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
# white
WHITE='\033[1;97m'

#########################################################################

#########################################################################
# Variable
#########################################################################

# Variable to argument in papa_script
target_computer=""
target_user="wilder"

#########################################################################
# Function
#########################################################################
execution_script_sudo()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_user sur la machine $target_computer et éxécution du $script_name${NC}"
                    scp "$chemin""$script_name" "$target_user"@"$target_computer":/tmp/ &> /dev/null
                        if [ $? -eq 0 ]
                        then
                            ssh -t "$target_user"@"$target_computer" "sudo bash /tmp/"$script_name""
                            if [ $? -eq 0 ]
                            then
                                echo -e "${GREEN}Le $script_name a été exécuter avec succès${NC}"
                                echo ""
                                ###########################################################################
                                # Retrieve directory 

                                # Define local directory for storing downloaded info files
                                local_info_dir="$HOME/Documents/TSSR-1025-P2-G1/ressources/scripts/info"
                                # Create the local /info directory if it does not exist
                                mkdir -p "$local_info_dir"
                                # Check if the retrieval was successful
                                scp "$target_user"@"$target_computer":/tmp/info/* "$local_info_dir"/  &> /dev/null
                                    if [ $? -eq 0 ]
                                    then
                                        echo "Les fichiers info ont été rapatriés dans $local_info_dir"
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
                                exit 1
                            fi
                            ssh "$target_user"@"$target_computer" "rm /tmp/"$script_name""
                                if [ $? -eq 0 ]
                                then
                                    echo "Le fichier $script_name a bien été effacer de $target_computer"
                                    echo ""
                                else
                                    echo -e "${RED} WARNING !!! ${NC} Le fichier $script_name n'a pas été supprimé de $target_computer"
                                    echo ""
                                    log_event_connexion "ERREURFichierNonSupprimeSortieSSH"
                                    exit 1
                                fi
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionner"
                            log_event_connexion "ERREURConnexionSSHouCheminScript"
                            exit 1
                        fi  
    }

#execution script PowerShell action
execution_script_windows()
    {
     local script_name="$1"   
     echo -e "${TITLE}Connexion à $target_computer et éxécution du $script_name${NC}"
                    scp "$chemin""$script_name" "$target_user"@"$target_computer":C:/Users/$target_user/Documents/ &> /dev/null
                    echo ""
                        if [ $? -eq 0 ]
                        then
                            ssh -t  "$target_user"@"$target_computer" "powershell.exe -ExecutionPolicy Bypass -File C:/Users/$target_user/Documents/$script_name"
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
                        else
                            echo -e "${RED} WARNING !!! ${NC} La connexion SSH où le chemin d'accès du script n'a pas fonctionné"
                             log_event_connexion "ERREURConnexionSSHouCheminScript"
                            return 1
                        fi  
    }
#########################################################################
# Script
#########################################################################

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
# menu name display
    clear
    echo -e "${TITLE}Utilisation de script à distance${NC}"
    echo ""
while true
do
    echo -e "${TITLE}Quel script voulez-vous utilisez à distance ?${NC}" 
    read -p "Le nom de votre script : " script_name
    echo ""
    read -p "Quel est le chemin pour acceder à ton script ?" chemin

    #verification que le script_name existe bien 
    chemin_complet="${chemin}/${script_name}"

    if [ ! -f "$chemin_complet" ]
    then
        echo -e "${RED}WARNING !${NC} Le script $script_name n'éxiste pas dans le chemin $chemin"
        echo ""
        read -p "Appuyer sur ENTER pour réessayer..."
        clear
    else
        echo -e "${GREEN}le script $script_name existe bien.${NC}"
        echo ""
        break
    fi
done
        if [ "$os_type" = "linux" ]
            then
                execution_script_sudo "$script_name"
            else
                execution_script_windows "$script_name"
            fi
   
exit 0
#########################################################################