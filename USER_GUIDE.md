# Sommaire

1. [Introduction](#1-introduction)
2. [Pré-requis d'utilisation](#2-pre-requis-dutilisation)
   - [Script Bash](#21-script-bash)
   - [Script PowerShell](#22-script-powershell)
3. [Lancer le script](#3-lancer-le-script)
   - [Sous Linux](#31-sous-linux)
   - [Sous Windows](#32-sous-windows)
4. [Navigation dans les menus](#4-navigation-dans-les-menus)
   - [Menu principal](#41-menu-principal)
   - [Sélection de la cible](#42-sélection-de-la-cible)
   - [Sélection des actions](#43-sélection-des-actions)
   - [Retour / Quitter](#44-retour--quitter)
5. [Fonctionnalités — Utilisateurs](#5-fonctionnalités--utilisateurs)
   - [Actions possibles](#51-actions-possibles)
   - [Informations récupérables](#52-informations-récupérables)
6. [Fonctionnalités — Machines clientes](#6-fonctionnalites--machines-clientes)
   - [Actions possibles](#61-actions-possibles)
   - [Informations récupérables](#62-informations-récupérables)
7. [Enregistrement des informations](#7-enregistrement-des-informations)
   - [Format des fichiers](#71-format-des-fichiers)
   - [Emplacement](#72-emplacement)
8. [Journalisation (Logs)](#8-journalisation-logs)
   - [Format des fichiers](#81-format-des-fichiers)
   - [Emplacement](#82-emplacement)
9. [Quitter le script](#9-quitter-le-script)
10. [FAQ](#10-faq)

# 1. Introduction

Ce document explique comment utiliser le script d'administration développé dans le cadre du Projet 2 TSSR.
Il est destiné aux utilisateurs finaux souhaitant exécuter les actions d'administration ou récupérer des informations sur les machines du réseau.

Les instructions couvrent :

- l'exécution du script Bash (serveur Debian),
- l'exécution du script PowerShell (serveur Windows),
- la navigation dans les menus,
- l'utilisation des fonctions disponibles.

---

# 2. Pré-requis d'utilisation
## 2.1. Script Bash

Le script Bash doit être exécuté depuis le serveur Debian (SRVLX01).<br>

**Pré-requis nécessaires :**
- Une connexion SSH fonctionnelle vers les machines clientes (CLILIN01 et CLIWIN01)
- Les clés SSH correctement configurées avec keychain
- La présence des scripts enfants dans le dossier `~/Documents/TSSR-1025-P2-G1/scripts/`
- Les permissions d'exécution sur le script principal (`chmod +x script_dady.sh`)
- L'utilisateur `wilder` doit exister sur toutes les machines du réseau

**Arborescence requise :**
```
~/Documents/TSSR-1025-P2-G1/
└── scripts/
    ├── script_dady.sh (script principal)
    ├── [scripts enfants .sh]
    └── info/ (dossier de réception des fichiers)
```

## 2.2. Script PowerShell

Le script PowerShell doit être exécuté depuis le serveur Windows (SRVWIN01).<br>

**Pré-requis nécessaires :**
- PowerShell Core 7.4+ installé sur le serveur
- Une connexion SSH fonctionnelle vers les machines clientes (CLILIN01 et CLIWIN01)
- Les clés SSH correctement configurées avec ssh-agent (service Windows)
- La présence des scripts enfants dans le dossier `C:\Users\<user>\Documents\TSSR-1025-P2-G1\scripts\`
- La politique d'exécution PowerShell configurée pour permettre l'exécution de scripts
- L'utilisateur `wilder` doit exister sur toutes les machines du réseau

**Arborescence requise :**
```
C:\Users\<user>\Documents\TSSR-1025-P2-G1\
└── scripts\
    ├── script_momy.ps1 (script principal)
    ├── [scripts enfants .ps1]
    └── info\ (dossier de réception des fichiers)
```

**Configuration de la politique d'exécution :**
Pour permettre l'exécution du script, ouvrir PowerShell en tant qu'administrateur et exécuter :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

# 3. Lancer le script
## 3.1. Sous Linux

1. Ouvrir un terminal sur le serveur Debian (SRVLX01).
2. Se rendre dans le dossier où se trouve le script :
   ```bash
   cd ~/Documents/TSSR-1025-P2-G1/scripts
   ```
3. Lancer le script :
   ```bash
   ./script_dady.sh
   ```
4. Le menu principal s'affiche automatiquement.

**Note :** Si vous obtenez une erreur "Permission denied", vérifiez que le script a les droits d'exécution :
```bash
chmod +x script_dady.sh
```

## 3.2. Sous Windows

1. Ouvrir PowerShell sur le serveur Windows (SRVWIN01).
2. Se rendre dans le dossier où se trouve le script :
   ```powershell
   cd C:\Users\<user>\Documents\TSSR-1025-P2-G1\scripts
   ```
3. Lancer le script :
   ```powershell
   .\script_momy.ps1
   ```
4. Le menu principal s'affiche automatiquement.

**Note :** Si vous obtenez une erreur de politique d'exécution, exécutez :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

# 4. Navigation dans les menus
## 4.1. Menu principal
Le menu principal permet de choisir si l'on veut administrer un **utilisateur** ou un **ordinateur**. <br>
Chaque choix ouvre un sous-menu dédié aux actions possibles.

**Options disponibles :**
- **1) Utilisateur** : Accès aux actions et informations concernant les comptes utilisateurs
- **2) Ordinateur** : Accès aux actions et informations concernant les machines clientes
- **3) Exit** : Fermeture du script

## 4.2. Sélection de la cible
Lorsqu'une action nécessite une machine ou un utilisateur, le script demande d'entrer le nom de la cible. 

**Exemples de cibles valides :**
- **Utilisateur** : `wilder`, `admin`, `john.doe`
- **Machine Linux** : `CLILIN01` (respecter la casse)
- **Machine Windows** : `CLIWIN01` (respecter la casse)

**Important :** 
- Le nom doit correspondre exactement à un utilisateur ou un poste existant dans votre réseau
- Le script détecte automatiquement le type d'OS (Linux ou Windows) de la machine cible
- La machine doit être accessible via SSH

## 4.3. Sélection des actions
Chaque menu propose une liste d'actions disponibles numérotées. <br>
Il suffit de taper le numéro correspondant à l'action souhaitée et d'appuyer sur Entrée. <br>
Le script exécute automatiquement la commande et revient ensuite au sous-menu.

**Navigation typique :**
```
Menu Principal → Ordinateur → Action → [Choix 1-9] → Exécution → Retour au menu Action
```

## 4.4. Retour / Quitter
- **Retour** : Permet de revenir au menu précédent sans fermer le script
- **Exit** : Ferme proprement le script et enregistre l'événement dans les logs
- À tout moment, vous pouvez choisir l'option de retour ou quitter

---

# 5. Fonctionnalités — Utilisateurs
## 5.1. Actions possibles

Le script permet d'effectuer les actions suivantes sur les comptes utilisateurs :

| Action | Description |
|--------|-------------|
| **1) Création de compte utilisateur local** | Crée un nouveau compte utilisateur sur la machine cible |
| **2) Changement de mot de passe** | Modifie le mot de passe d'un utilisateur existant |
| **3) Suppression de compte utilisateur local** | Supprime un compte utilisateur de la machine cible |
| **4) Ajout à un groupe d'administration** | Ajoute un utilisateur au groupe sudo (Linux) ou Administrators (Windows) |
| **5) Ajout à un groupe** | Ajoute un utilisateur à un groupe personnalisé |
| **6) Modification de permission sur un répertoire** | Change les permissions d'accès d'un utilisateur sur un dossier spécifique |

**Notes importantes :**
- Toutes ces actions nécessitent des droits administrateur sur la machine cible
- L'utilisateur doit exister sur la machine cible pour les actions 2, 3, 4, 5 et 6
- Les modifications sont journalisées dans le fichier `log_evt.log`

## 5.2. Informations récupérables

Le script permet de consulter les informations suivantes concernant un utilisateur :

| Information | Description |
|-------------|-------------|
| **Droits/permissions sur un dossier** | Affiche les permissions d'un utilisateur sur un répertoire spécifique |

**Exemple de contenu du fichier d'information :**
```
Utilisateur : wilder
Dossier : /home/wilder/Documents
Permissions : rwxr-xr-x
Date de récupération : 20241218_143022
```

---

# 6. Fonctionnalités — Machines clientes
## 6.1. Actions possibles

Le script permet d'effectuer les actions suivantes sur les machines clientes :

| Action | Description |
|--------|-------------|
| **1) Verrouillage** | Verrouille la session de l'utilisateur distant |
| **2) Redémarrage** | Redémarre la machine distante |
| **3) Activation du pare-feu** | Active le pare-feu système (ufw sur Linux, Windows Firewall sur Windows) |
| **4) Création de répertoire** | Crée un nouveau dossier sur la machine distante |
| **5) Suppression de répertoire** | Supprime un dossier existant sur la machine distante |
| **6) Prise de main à distance (CLI)** | Ouvre une session SSH interactive vers la machine cible |
| **7) Exécution de script sur la machine distante** | Permet d'exécuter un script personnalisé sur la machine cible |

**Notes importantes :**
- Les actions 2, 3, 4 et 5 nécessitent des droits administrateur
- L'action 2 (Redémarrage) provoque une déconnexion immédiate
- L'action 6 ouvre une session interactive (taper `exit` pour revenir au menu)
- Toutes les actions sont journalisées dans le fichier `log_evt.log`

## 6.2. Informations récupérables

Le script peut récupérer les informations système suivantes :

| Information | Description |
|-------------|-------------|
| **1) Adresse IP, masque, passerelle** | Configuration réseau de la machine |
| **2) Version de l'OS** | Système d'exploitation et version |
| **3) Carte graphique** | Modèle de GPU installé |
| **4) CPU %** | Utilisation actuelle du processeur |
| **5) Uptime** | Temps depuis le dernier démarrage |
| **6) Température CPU** | Température du processeur |
| **7) Nombre de disque** | Nombre de disques physiques |
| **8) Partition (nombre, nom, FS, taille) par disque** | Détails des partitions |
| **9) Espace disque restant par partition/volume** | Espace disponible sur chaque partition |
| **10) Liste des utilisateurs locaux** | Liste de tous les comptes utilisateurs |
| **11) 5 derniers logins** | Historique des 5 dernières connexions |
| **12) 10 derniers événements critiques** | Événements système critiques récents |
| **13) Recherche des événements dans log_evt.log** | Recherche d'événements spécifiques dans les logs du script |

**Notes importantes :**
- Toutes les informations sont sauvegardées dans des fichiers `info_<machine>_<date>.txt`
- Les informations 3, 6 et 12 peuvent nécessiter des droits sudo sur certains systèmes
- Les fichiers sont automatiquement rapatriés sur le serveur dans le dossier `scripts/info/`

---

# 7. Enregistrement des informations
## 7.1. Format des fichiers

Les informations récupérées sont enregistrées dans un fichier texte nommé :<br>
```
info_<cible>_<date>.txt
```

**Exemple de nom de fichier :**
- `info_CLILIN01_20241218_143022.txt` (informations sur la machine CLILIN01)
- `info_wilder_20241218_143022.txt` (informations sur l'utilisateur wilder)

**Format de la date :**
- `YYYYMMDD_HHMMSS` (Année Mois Jour _ Heure Minute Seconde)
- Exemple : `20241218_143022` = 18 décembre 2024 à 14h30:22

## 7.2. Emplacement

Les fichiers d'informations suivent un cycle en 3 étapes :

### Étape 1 : Création sur la machine cliente
Les scripts enfants créent d'abord les fichiers sur la machine distante :
- **Linux (CLILIN01)** : `~/Documents/info/info_<cible>_<date>.txt`
- **Windows (CLIWIN01)** : `C:\Users\wilder\Documents\info\info_<cible>_<date>.txt`

### Étape 2 : Rapatriement automatique
Les fichiers sont ensuite **automatiquement copiés** sur le serveur qui a exécuté le script :

**Depuis SRVLX01 (Debian) :**
```
~/Documents/TSSR-1025-P2-G1/scripts/info/
```

**Depuis SRVWIN01 (Windows Server) :**
```
C:\Users\<user>\Documents\TSSR-1025-P2-G1\scripts\info\
```

### Étape 3 : Nettoyage
Les fichiers sont supprimés de la machine cliente après le rapatriement pour éviter l'accumulation.

**Important :** Toutes les informations sont centralisées côté serveur et consultables hors connexion.

---

# 8. Journalisation (Logs)
## 8.1. Format des fichiers

Chaque action effectuée par le script est enregistrée dans le fichier de log. <br>
Le format comprend la date, l'heure, l'utilisateur et l'action réalisée.<br>

Les informations sont enregistrées dans un fichier log nommé :<br>
```
log_evt.log
```

**Format des entrées de log :**

Pour les actions de navigation :
```
YYYYMMDD_HHMMSS_utilisateur_événement
```

Pour les actions sur une cible :
```
YYYYMMDD_HHMMSS_utilisateur_événement_targetuser_targetcomputer
```

**Exemples d'entrées :**
```
20241218_143022_wilder_MenuPrincipal
20241218_143045_wilder_MenuActionOrdinateur
20241218_143102_wilder_ActionRedemarrage_wilder_CLILIN01
20241218_143215_wilder_InformationVersionOs_wilder_CLIWIN01
```

**Types d'événements journalisés :**
- Navigation dans les menus (MenuPrincipal, MenuUtilisateur, MenuOrdinateur, etc.)
- Actions effectuées (ActionRedemarrage, ActionCreationCompteUtilisateur, etc.)
- Informations récupérées (InformationVersionOs, InformationIP, etc.)
- Connexions SSH (ConnexionSSH, DeconnexionSSH)
- Erreurs (ErreurNavigation, ErreurConnexion, etc.)

## 8.2. Emplacement

Le fichier de log se trouve dans des emplacements différents selon le serveur utilisé :

**Depuis SRVLX01 (Debian) :**
```
/var/log/log_evt.log
```

**Depuis SRVWIN01 (Windows Server) :**
```
C:\Windows\System32\LogFiles\log_evt.log
```

**Accès au fichier de log :**

**Sur Linux :**
```bash
# Consulter les 20 dernières lignes
tail -n 20 /var/log/log_evt.log

# Rechercher un événement spécifique
grep "CLILIN01" /var/log/log_evt.log

# Suivre en temps réel
tail -f /var/log/log_evt.log
```

**Sur Windows :**
```powershell
# Consulter les 20 dernières lignes
Get-Content C:\Windows\System32\LogFiles\log_evt.log -Tail 20

# Rechercher un événement spécifique
Select-String -Path C:\Windows\System32\LogFiles\log_evt.log -Pattern "CLIWIN01"
```

---

# 9. Quitter le script

Pour quitter le script, sélectionnez l'option **"Exit"** dans n'importe quel menu. <br>

**Ce qui se passe lors de la fermeture :**
1. Le script enregistre l'événement "EndScript" dans le fichier de log
2. Un message de confirmation s'affiche : `Exit - FIN DE SCRIPT`
3. Le script se termine proprement en libérant toutes les ressources
4. Vous revenez au terminal/PowerShell

**Important :** 
- N'utilisez pas `Ctrl+C` pour fermer le script, privilégiez toujours l'option "Exit"
- Cela garantit que l'événement de fermeture est bien journalisé
- Les connexions SSH sont correctement fermées

---

**📖 Pour plus d'informations :**
- [INSTALL.md](INSTALL.md) - Guide d'installation et de configuration
- [README.md](README.md) - Documentation technique du projet

# 10. FAQ

## Questions générales

**Q : Quelles machines puis-je administrer avec ce script ?**<br>
R : Le script peut administrer les machines suivantes :
- CLILIN01 (172.16.10.30) - Ubuntu 24 LTS
- CLIWIN01 (172.16.10.20) - Windows 10/11

Les machines doivent être accessibles via SSH et l'utilisateur `wilder` doit exister dessus.

**Q : Le script fonctionne-t-il avec d'autres utilisateurs que `wilder` ?**<br>
R : Actuellement, le script est configuré pour utiliser l'utilisateur `wilder` par défaut. Pour utiliser d'autres utilisateurs, il faudrait modifier les scripts enfants et la configuration SSH.

**Q : Puis-je exécuter le script depuis n'importe quelle machine ?**<br>
R : Non, le script doit être exécuté depuis l'un des serveurs :
- `script_dady.sh` depuis SRVLX01 (Debian)
- `script_momy.ps1` depuis SRVWIN01 (Windows Server)

## Erreurs de connexion SSH

**Q : Le script ne trouve pas ma machine.**<br>
R : Vérifiez les points suivants :
- Le nom de la machine est correct (CLILIN01 ou CLIWIN01, respecter la casse)
- La machine est bien démarrée et accessible sur le réseau
- La connexion SSH fonctionne : `ssh wilder@CLILIN01` ou `ssh wilder@172.16.10.30`
- Les clés SSH sont correctement configurées

**Q : J'obtiens une erreur "Permission denied" lors de la connexion SSH.**<br>
R : Cela signifie que l'authentification SSH a échoué. Vérifiez :
- Les clés SSH sont bien installées sur la machine cible
- Le service ssh-agent (Windows) ou keychain (Linux) est actif sur le serveur
- Testez manuellement : `ssh wilder@CLILIN01`
- Les permissions de la clé privée sont correctes (600) : `chmod 600 ~/.ssh/id_ed25519`

**Q : Le script se bloque lors de l'exécution d'une action SSH.**<br>
R : Causes possibles :
- La machine cible est en train de redémarrer
- Un script enfant est bloqué en attente d'une saisie utilisateur
- Problème réseau temporaire
- Appuyez sur `Ctrl+C` pour interrompre, puis vérifiez la connectivité

**Q : J'obtiens "Host key verification failed".**<br>
R : Cette erreur apparaît lors de la première connexion SSH. Solutions :
- Connectez-vous manuellement une fois : `ssh wilder@CLILIN01` et acceptez l'empreinte
- Ou supprimez l'ancienne clé : `ssh-keygen -R CLILIN01`

## Problèmes de scripts et fichiers

**Q : Aucun fichier d'informations n'apparaît.**<br>
R : Vérifiez que :
- Les scripts enfants sont bien présents dans le dossier `scripts/`
- Les scripts enfants ont les droits d'exécution (chmod +x sur Linux)
- Le dossier `scripts/info/` existe sur le serveur
- L'action s'est exécutée sans erreur (consultez les logs)

**Q : Comment revenir en arrière dans les menus ?**<br>
R : Chaque menu propose une option "Retour" permettant de revenir au menu précédent sans fermer le script.

**Q : Un script enfant semble manquant.**<br>
R : Vérifiez que tous les scripts enfants sont bien présents dans le dossier `scripts/` :
```bash
# Sur Linux
ls -la ~/Documents/TSSR-1025-P2-G1/scripts/*.sh

# Sur Windows
Get-ChildItem C:\Users\<user>\Documents\TSSR-1025-P2-G1\scripts\*.ps1
```

**Q : Le script principal ne démarre pas.**<br>
R : Causes possibles :
- **Linux** : Le script n'a pas les droits d'exécution → `chmod +x script_dady.sh`
- **Windows** : La politique d'exécution bloque les scripts → `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Le fichier est corrompu → Retéléchargez depuis le dépôt GitHub

## Problèmes spécifiques Linux

**Q : J'obtiens "sudo: no tty present and no askpass program specified".**<br>
R : Certaines actions nécessitent sudo. Solutions :
- Configurez sudo NOPASSWD pour l'utilisateur wilder (voir INSTALL.md)
- Ou exécutez le script avec sudo : `sudo ./script_dady.sh`

**Q : Le fichier de log n'est pas créé sur Debian.**<br>
R : Vérifiez les permissions :
```bash
sudo touch /var/log/log_evt.log
sudo chmod 666 /var/log/log_evt.log
```

## Problèmes spécifiques Windows

**Q : PowerShell refuse d'exécuter le script.**<br>
R : Modifiez la politique d'exécution :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Q : Les chemins avec espaces causent des erreurs.**<br>
R : Assurez-vous d'utiliser des guillemets autour des chemins :
```powershell
cd "C:\Users\John Doe\Documents\TSSR-1025-P2-G1\scripts"
```

## Journalisation et historique

**Q : Comment consulter l'historique des actions effectuées ?**<br>
R : Consultez le fichier `log_evt.log` :
```bash
# Sur Linux
tail -n 50 /var/log/log_evt.log

# Sur Windows
Get-Content C:\Windows\System32\LogFiles\log_evt.log -Tail 50
```

**Q : Puis-je rechercher un événement spécifique dans les logs ?**<br>
R : Oui, utilisez grep (Linux) ou Select-String (Windows) :
```bash
# Sur Linux - rechercher tous les événements concernant CLILIN01
grep "CLILIN01" /var/log/log_evt.log

# Sur Windows
Select-String -Path C:\Windows\System32\LogFiles\log_evt.log -Pattern "CLILIN01"
```

## Dépannage avancé

**Q : Comment vérifier que SSH fonctionne correctement ?**<br>
R : Testez manuellement depuis le serveur :
```bash
# Test de connexion
ssh wilder@CLILIN01

# Test avec sortie détaillée pour déboguer
ssh -v wilder@CLILIN01
```

**Q : Où puis-je trouver plus d'aide ?**<br>
R : Consultez la documentation complète :
- [INSTALL.md](INSTALL.md) - Guide d'installation et configuration SSH
- [README.md](README.md) - Présentation du projet et choix techniques
- Logs du script : `/var/log/log_evt.log` ou `C:\Windows\System32\LogFiles\log_evt.log`

---
