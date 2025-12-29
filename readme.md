## Sommaire 

1. [ Introduction](#1-introduction)
2. [ Présentation du projet](#2-présentation-du-projet)
3. [ Membres du groupe par sprint](#3-membres-du-groupe-par-sprint)
4. [ Prérequis techniques](#4-prérequis-techniques)
5. [ Choix techniques](#5-choix-techniques)
6. [ Difficultés rencontrées](#6-difficultés-rencontrées)
7. [ Solutions trouvées](#7-solutions-trouvées)
8. [ Améliorations possibles](#8-améliorations-possibles)

# 1. Introduction

Le but est de concevoir et développer un outil d'administration centralisée, capable de gérer et de superviser des systèmes s'exécutant sur diverses plateformes.

# 2. Présentation du projet

L'objectif principal est de fournir une interface facilitant l'exécution de tâches via des scripts telles que la configuration, le déploiement de correctifs, la gestion des utilisateurs et la surveillance des performances, réduisant ainsi la complexité opérationnelle et améliorant l'efficacité et la sécurité à travers l'ensemble du parc informatique, depuis des servers Debian et Windows vers des clients Linux et Windows.

# 3. Membres du groupe par sprint

**Sprint 1**

| Membre      | Rôle       | Missions                                                                                                          |
| ----------- | ---------- | ----------------------------------------------------------------------------------------------------------------- |
| Franck        | PO         | Configuration des machines clients ( Ubuntu/Windows 11 ) / Pseudo-code / Renseignements sur la connexion SSH / Squelette INSTALL.md GitHub|
| Nicolas     | SM         | Configuration du server Debian CLI / Pseudo-code / Renseignements sur la journalisation / Squelette README.md Github   |
| Matthias     | Technicien | Configuration du server Windows / Pseudo-code / Renseignements sur l'ergonomie et la navigation dans le script / Squelette USER_GUIDE.md Github|

**Sprint 2**

| Membre      | Rôle       | Missions                                                                                                          |
| ----------- | ---------- | ----------------------------------------------------------------------------------------------------------------- |
| Matthias        | PO        | Scripting Bash / Mise en place et ajustement de l'ergonomie du script / Aide Journalisation / Scripting PowerShell|
| Franck     | SM         | Scripting Bash/ Finalisation de la connexion SSH / Mise à jour INSTALL.md GitHub Test du script Bash et mise en production sur Proxmox |
| Nicolas     | Technicien | Scripting Bash / Journalisation  / Test sur Proxmox /Mise à jour README.md Github |

**Sprint 3**

| Membre      | Rôle       | Missions                                                                                                          |
| ----------- | ---------- | ----------------------------------------------------------------------------------------------------------------- |
| Franck        | Technicien   | Scripting Bash / Mise au propre script bash / Test du script Bash et mise en production sur Proxmox |
| Nicolas     | PO      | Scripting Bash / Mise en place et ajustement de l'ergonomie du script Powershell |
| Matthias     | SM | Scripting Bash / Mise en place de la récupération d'information / Scripting PowerShell / Documentation du script bash / Mise à jour README.md Github |

**Sprint 4**

| Membre      | Rôle       | Missions                                                                                                          |
| ----------- | ---------- | ----------------------------------------------------------------------------------------------------------------- |
| Franck        | PO   | Test-Debug Scripts Parents / Amélioration visuel des Scripts Parents |
| Nicolas     |   SM    |  Scripting PowerShell / Test-Debug Scripts Parents |
| Matthias     | Technicien | Scripting Bash / Scripting PowerShell / Test-Debug Scripts Enfants / Documentation finale |

# 4. Prérequis techniques

Avant de déployer l'outil d'administration centralisée, les éléments suivants doivent être en place :

## Infrastructure réseau
- Réseau : 172.16.10.0/24
- Passerelle : 172.16.10.254
- Masque : 255.255.255.0
- DNS : 8.8.8.8

## Machines virtuelles
4 VMs hébergées sur Proxmox :

| Machine  | IP            | OS                           | Rôle                    |
|----------|---------------|------------------------------|-------------------------|
| SRVLX01  | 172.16.10.10  | Debian 12/13 CLI             | Serveur principal       |
| SRVWIN01 | 172.16.10.5   | Windows Server 2022/2025 GUI | Serveur secondaire      |
| CLILIN01 | 172.16.10.30  | Ubuntu 24 LTS                | Client Linux            |
| CLIWIN01 | 172.16.10.20  | Windows 10/11                | Client Windows          |

## Logiciels requis

### Sur SRVLX01 (Debian) :
- OpenSSH Server
- keychain (gestion des clés SSH)
- Bash 4.0+

### Sur SRVWIN01 (Windows Server) :
- OpenSSH Server (Windows Feature)
- PowerShell Core 7.4+ minimum
- ssh-agent (service Windows)

### Sur CLILIN01 (Ubuntu) :
- OpenSSH Server

### Sur CLIWIN01 (Windows) :
- OpenSSH Server (Windows Feature)

## Compte utilisateur
- Un compte utilisateur **`wilder`** doit exister sur les 4 machines
- Avec les mêmes permissions (sudo/admin selon l'OS)
- Utilisé pour toutes les connexions SSH

## Arborescence de fichiers

### SRVLX01 (Debian) :
```
~/Documents/TSSR-1025-P2-G1/
└── scripts/
    ├── script_dady.sh
    ├── [scripts enfants .sh]
    └── info/  (fichiers rapatriés)
```

### SRVWIN01 (Windows Server) :
```
C:\Users\<user>\Documents\TSSR-1025-P2-G1\
└── scripts\
    ├── script_momy.ps1
    ├── [scripts enfants .ps1]
    └── info\  (fichiers rapatriés)
```

### Clients (auto-créés par les scripts) :
- CLILIN01 : `~/Documents/info/`
- CLIWIN01 : `C:\Users\wilder\Documents\info\`

---

**Note :** Pour les instructions d'installation détaillées, consulter [INSTALL.md](INSTALL.md)

# 5. Choix techniques

## Logiciels :    

   - OpenSSH Server (sur toutes les machines)
   - Keychain (sur SRVLX01 - Debian)
   - ssh-agent (sur SRVWIN01 - Windows Server)
   - PowerShell Core 7.4+ (sur SRVWIN01)

### Détails des choix SSH et PowerShell :

**Authentification SSH par clés :**
- Type de clé : **ed25519** (plus sécurisée et performante que RSA)
- Gestion des clés sur Debian : **keychain** (persiste les clés entre les sessions)
- Gestion des clés sur Windows : **ssh-agent** (service Windows natif)

**PowerShell Core :**
- Version minimale : **7.4+** (requis pour SRVWIN01)
- Avantages : compatibilité multiplateforme, performances améliorées, syntaxe moderne
- Installation : via `winget install Microsoft.PowerShell`

**Compte utilisateur uniforme :**
- Un utilisateur identique **`wilder`** est créé sur les 4 machines
- Facilite la gestion SSH et les permissions
- Simplifie les scripts (pas de gestion multi-utilisateurs)


Afin de garantir la modularité, la maintenabilité et la portabilité de l'outil, plusieurs choix techniques ont été faits au cours du développement :
## Architecture globale : un script principal + scripts enfants
Nous avons adopté une architecture en **script principal ("script dady")** chargé de :
- Gérer la navigation par menus
- Journaliser les actions
- Établir la connexion SSH vers les postes clients
- Exécuter des scripts enfants envoyés temporairement dans un dossier défini a l'avance
- Rapatrier les fichiers d'informations générés sur les machines distantes

Les **scripts enfants** qui eux sont chargées de :
- Réaliser une actions ou d'aller chercher une information
- Créer un fichier de récupération de l'information demandé

Cela nous permet de :
- Simplifier la maintenance
- Isoler les erreurs
- Permettre une exécution indépendante
- Rendre le code plus lisible et évolutif

## Transmission des scripts via SSH
Le script principal utilise :
- `scp` pour transmettre le script enfant vers `/tmp/` du poste client
- `ssh` pour l'exécuter
- `scp` à nouveau, pour récupérer le fichier d'information
- Puis un nettoyage automatique du fichier distant

Pour les postes Windows, le fonctionnement est légèrement différent. 
Les scripts enfants PowerShell sont envoyés dans le dossier :
`C:/Users/$target_user/Documents/info/*`
Une fois copiés, ils sont exécutés via PowerShell avec :
`powershell.exe -ExecutionPolicy Bypass -File C:\Users\<target_user>\Documents\<script>.ps1`
Puis ils sont supprimés automatiquement après l'exécution, comme pour Linux.

Ce choix permet :
- La compatibilité multi-OS
- Un code centralisé exclusivement côté serveur

## Détection automatique de l'OS distant

Le script principal détecte automatiquement si le poste distant est Linux ou Windows.

La détection se fait via une commande SSH simple :
```bash
ssh user@machine "[ -d /etc ]"
```
**Fonctionnement :**
- Si le dossier `/etc` existe → système **Linux** (code retour 0)
- Si le dossier `/etc` n'existe pas → système **Windows** (code retour 1)

**Pourquoi `/etc` ?**
- `/etc` est un dossier système standard présent sur **tous** les systèmes Linux/Unix
- Windows **n'a pas** ce dossier dans son arborescence
- Méthode simple, rapide et fiable

**Avantages de cette détection :**
- Évite les erreurs de sélection manuelle
- Adapte automatiquement les commandes d'exécution :
  - Linux → `bash /tmp/script.sh`
  - Windows → `powershell.exe -ExecutionPolicy Bypass -File C:\Users\...\script.ps1`
- Rend les scripts plus robustes et maintenables

## Journalisation
Une fonctionnalité de **journalisation centralisée** a été intégrée :
- Chaque action, navigation, erreur ou opération SSH est tracée
- Deux formats standardisés ont été adoptés :  
   -  `YYYYMMDD_HHMMSS_utilisateur_événement`
   - `YYYYMMDD_HHMMSS_utilisateur_événement_targetuser_targetcomputer`
- Le fichier de log est créé automatiquement si absent
- Le fichier se crée à des endroits différents en fonction du serveur :
   - Debian : `/var/log/log_evt.log`
   - Windows server : `C:\Windows\System32\LogFiles\log_evt.log`

Ce choix permet une supervision claire et un audit complet du script.

## Récupération des informations
Chaque script enfant suit un **modèle standardisé** :
- Définition d'un `info_target` (hostname ou utilisateur)
- Les scripts enfants enregistrent désormais les informations dans un dossier persistant :
   - Linux : ~/Documents/info/
   - Windows : C:/Users/<target_user>/Documents/info/
- Mise en forme de la donnée (value)
- Écriture homogène dans un fichier `info_<cible>_<date>.txt`

Cette approche garantit que :
- Toutes les informations systèmes suivent le même format
- La structure répond précisément aux contraintes du projet

## Rapatriement automatique des fichiers d'informations
À chaque exécution réussie d'un script enfant, le script principal :
Pour Debian :
Depuis un poste Linux, les fichiers d'informations sont rapatriés depuis :
~/Documents/info/

Depuis un poste Windows :
C:/Users/<target_user>/Documents/info/

Ces fichiers sont ensuite copiés automatiquement dans le dossier local du projet :
~/Documents/TSSR-1025-P2-G1/scripts/info

Pour Windows Server :
Depuis un poste Linux, les fichiers d'informations sont rapatriés depuis :
~/Documents/info/

Depuis un poste Windows :
C:\Users\<target_user>\Documents\info\

Ces fichiers sont ensuite copiés automatiquement dans le dossier local du projet :
C:\Users\<user>\Documents\TSSR-1025-P2-G1\scripts\info\

Ce choix permet d'avoir **toutes les informations regroupées côté serveur** et consultables hors connexion.

# 6. Difficultés rencontrées 

## Exécution SSH et droits sudo
L'exécution de scripts distants avec `ssh` et `sudo` a nécessité :
- Une bonne gestion des prompts
- Une adaptation de la syntaxe
- Le choix d'un comportement cohérent selon les actions

Certaines commandes nécessitaient obligatoirement les droits administrateur.

## Journalisation
La mise en place d'un système de log unifié a été complexe :
- Format homogène
- Événements pertinents
- Récupération des variables `target_user` et `target_computer`
- Erreurs liées à l'interprétation du format date (`%Y%m%d`)

## Uniformisation des scripts enfants
Il a fallu concevoir une structure reproductible pour :
- La récupération d'informations
- Le formatage
- L'enregistrement dans des fichiers cohérents
- La compatibilité avec l'architecture centrale

Afin d'obtenir un résultat propre, exploitable et conforme au projet.

# 7. Solutions trouvées

## Standardisation des scripts enfants avec un template
Un **template enfant** a été créé pour :
- Définir la cible (machine / user)
- Créer automatiquement `/Documents/info`
- Formater les données
- Assurer la cohérence des fichiers produits

## Rapatriement automatique des informations
Après l'exécution SSH, le script principal récupère automatiquement, le fichier de récupération d'information créer par les scripts enfants.
Cela garantit la centralisation et l'organisation des données.

## Journalisation stabilisée
Les fonctions de log ont été réécrites avec :
- Des variables locales
- Un format de date correct
- Une concaténation propre
- Des événements distincts par type (navigation / action / information / connexion)

## Menu ergonomique et navigation claire
La navigation a été structurée en :
- Menu principal
- Menu utilisateur (action / information)
- Menu ordinateur (action / information)

Et chaque choix est tracé dans le fichier log.

## Choix des commandes fiables pour les informations système
Pour garantir la compatibilité multi-Linux :
- `/tmp/info` pour stocker les informations de manière isolée

# 8. Améliorations possibles

## Sélection dynamique de l'utilisateur pour les actions
Aujourd'hui, certaines actions utilisent l'utilisateur défini par défaut (`wilder`).  
Une amélioration serait d'intégrer :
- Une liste interactive des utilisateurs locaux
- Une sélection dynamique dans les menus

## Interface plus moderne
Le script pourrait évoluer vers :
- Une interface semi-graphique (whiptail / dialog)
- Une version GUI PowerShell pour Windows

## Gestion des erreurs améliorée
- Vérification avancée des retours SSH
- Détection des scripts manquants
- Validation syntaxique automatique avant exécution

## Sécurité
- Changement du port 22 pour SSH par le port 2222