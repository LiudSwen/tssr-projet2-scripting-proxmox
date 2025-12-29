
## Sommaire

1. [Prérequis techniques](#1-prérequis-technique)
   - [1.1 Prérequis Proxmox](#11-prérequis-proxmox)
   - [1.2 Prérequis pour le script principal Bash](#12-prérequis-pour-le-script-principal-bash)
   - [1.3 Prérequis pour le script principal PowerShell](#13-prérequis-pour-le-script-principal-powershell)

2. [Installation sur le serveur Debian (Debian 12.9)](#2-installation-sur-le-serveur-debian--debian-129-)
   - [2.1 Installation de OpenSSH-Server](#21-installation-de--open-ssh-server)
   - [2.2 Création d'une paire de clés Debian](#22-création-dune-paire-de-clés-debian)
   - [2.3 Copie de la clé publique sur CLIWIN01](#23-copie-de-la-clé-publique-sur-cliwin01)
   - [2.4 Copie de la clé publique sur CLILIN01](#24-copie-de-la-clé-publique-sur-clilin01)
   - [2.5 Installation de keychain](#25-installation-de-keychain)
   - [2.6 Préparation du serveur Debian pour le script principal](#26-préparation-du-serveur-debian-pour-le-script-principal)

3. [Installation sur le serveur Windows (Windows Server 2022)](#3-installation-sur-le-serveur-windows--windows-serveur-2022-)
   - [3.1 Installation OpenSSH-Client en GUI](#31-installation-openssh-client-en-gui)
   - [3.2 Création d'une paire de clés Windows-Serveur](#32-création-dune-paire-de-clés-windows-serveur)
   - [3.3 Copie de la clé publique sur CLIWIN01](#33-copie-de-la-clé-publique-sur-cliwin01)
   - [3.4 Copie de la clé publique sur CLILIN01](#34-copie-de-la-clé-publique-sur-clilin01)
   - [3.5 Installation et activation de AGENT-SSH](#35-installation-et-activation-de-agentssh)
   - [3.6 Configuration automatique au démarrage](#36-configuration-automatique-au-demarrage)
   - [3.7 Préparation du serveur Windows pour le script principal](#37-préparation-du-serveur-windows-pour-le-script-principal)


4. [Installation sur le client Windows (Windows 11)](#4-installation-sur-le-client-windows--windows-11-)
   - [4.1 Installation OpenSSH en CLI](#41-installation-open-ssh-en-cli-pour-la-connexion-avec-debian)
   - [4.2 Modification du fichier de configuration SSH](#42-modification-du-fichier-de-configuration-ssh)
   - [4.3 Dossier d'informations pour les scripts enfants](#43-dossier-dinformations-pour-les-scripts-enfants)

5. [Installation sur le client Linux (Ubuntu 24.04 LTS)](#5-installation-sur-le-client-linux--ubuntu-2404-lts-)
   - [5.1 Installation de OpenSSH-Server](#51-installation-de-openssh-server)
   - [5.2 Configuration du fichier SSH](#52-configuration-du-fichier-de-configuration-ssh)
   - [5.3 Dossier d'informations pour les scripts enfants](#53-dossier-dinformations-pour-les-scripts-enfants)

6. [Vérification de la configuration](#6-vérification-de-la-configuration)

7. [FAQ](#7-faq)



## 1. Prérequis technique

### 1.1 Prérequis Proxmox
Nous devons avoir 4 machines Virtuelle sous **PROXMOX** :

- Serveur Debian : 
	Nom : **SRVLX01**
	IP : **172.16.10.10/24**
	
 - Serveur Windows 2022
	Nom : **CLIWIN01**
	IP : **172.16.10.5/24**

- Client Windows 11 :
	Nom : **CLIWIN01**
	IP : **172.16.10.20/24**
		
- Client Linux :
	Nom : **CLILIN01**
	IP : **172.16.10.30/24**

Il faut un compte **ROOT** et **Administrator** sur les 2 serveurs
Il faut un compte utilisateur **wilder** sur les 4 VM
Passerelle par défaut : **172.16.10.254**
Masque de sous-réseau : **255.255.255.0**
DNS : **8.8.8.8**

### 1.2 Prérequis pour le script principal bash
Le script principal bash `script_dady.sh` nécessite :

1. **Accès SSH** configuré vers les machines clientes (Windows et Linux)
2. **Structure de dossiers** suivante sur le serveur Debian :
   ```
   ~/Documents/TSSR-1025-P2-G1/
   ├── scripts/
   │   ├── script_dady.sh
   │   ├── [scripts enfants bash]
   │   └── info/              # Dossier de destination des fichiers d'informations (qui se créer automatiquement par le script)
   ```

3. **Fichier de log** accessible en écriture :
   ```bash
   sudo touch /var/log/log_evt.log
   sudo chmod 666 /var/log/log_evt.log
   ```

4. **Scripts enfants** placés dans : `~/Documents/TSSR-1025-P2-G1/scripts/`

### 1.3 Prérequis pour le script principal PowerShell

Le script principal PowerShell `script_momy.ps1` nécessite :

1. **Accès SSH** configuré vers les machines clientes (Windows et Linux)
2. **Structure de dossiers** suivante sur le serveur Windows :
   ```
   C:\Users\<votre_utilisateur>\Documents\TSSR-1025-P2-G1\
   ├── scripts\
   │   ├── script_momy.ps1
   │   ├── [scripts enfants PowerShell]
   │   └── info\              # Dossier de destination des fichiers d'informations (qui se créer automatiquement par le script)
   ```

3. **Fichier de log** accessible en écriture :
   ```powershell
   New-Item -Path "C:\Windows\System32\LogFiles\log_evt.log" -ItemType File -Force
   ```

4. **PowerShell Core 7.4** ou supérieur installé
5. **Scripts enfants** placés dans : `C:\Users\<utilisateur>\Documents\TSSR-1025-P2-G1\scripts\`

## 2. Installation sur le serveur Debian ( Debian 12.9 )

### 2.1 Installation de  Open SSH-Server.

Logiquement sur Debian le logiciel **OpenSHH** est installé nativement. Voici la commande pour vérification :

```bash
apt-cache policy openssh-server
```

Voici la Capture d'écran :

 ![image](ressources/images/SRVLX01/debian_statut_openssh.png)
 
  
Nous pouvons constater que **OpenSHH** est bien installé et que nous avons la version 10.0.

Si **OpenSSH** n'est pas installé voici la commande :

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install openssh-server
```

Maintenant vérifions l'état du serveur *SSH*  avec cette commande :

```bash
systemctl status sshd
```


![image](ressources/images/SRVLX01/statut_fonctionnement-openssh_debian.png)

Nous voyons que le statut est bien en mode *active*.

Si cela n'est pas le cas voici la commande pour démarrer le service :

```bash
systemctl start sshd
```

### 2.2 Création d'une paire de clés Debian

Pour générer la paire de clés voici la commande :

```bash
ssh-keygen -t ed25519 -C "wilder@debian-lab"
```
![Screenshots](ressources/images/SRVLX01/generate_keys_SRVLX01.png)
A cette première interrogation, cela nous demande ou on veux stocker la clé. Si on veux la laisser par défaut il faut juste appuyer sur la touche "**ENTREE**" de votre clavier.

Remplir impérativement la **passphrase** ,cela seras le seul mot de passe à retenir pour toutes vos connexions sur vos serveurs possédant cette clé.

![Screenshots](ressources/images/SRVLX01/keys_SRVLX01.png)


### 2.3 Copie de la clé Publique sur *CLIWIN01*.

Au préalable nous devons exécuter les tâches du paragraphe "**4.1 Installation OpenSHH**."

Ensuite nous devons créé sur la machine Windows le dossier **.ssh** :

```bash
ssh wilder@CLIWIN01 "mkdir .ssh"
```

On devra saisir le mot de passe *SSH* de l'utilisateur visé.

Puis on copie la clé *Publique* sur la machine Windows avec cette commande :

```bash
scp ~/.ssh/id_ed25519.pub wilder@CLIWIN01:.ssh/authorized_keys
```

### 2.4 Copie de la clé Publique sur *CLILIN01*.

Au préalable nous devons exécuter les tâches du paragraphe "**5.1 Installation OpenSHH**."

Ensuite on copie la clé *Publique* sur la machine Linux avec cette commande :

```bash
ssh-copy-id wilder@CLILIN01
```
Nous devrions avoir cette affichage :

![screenshot](ressources/images/SRVLX01/add_copy_keyspub_clilin01.png)

### 2.5 Installation de keychain

Pour évité d'avoir a taper notre *Passphrase* à chaque connexion **SSH** installons **Keychain** avec ces commandes :

On va commencer par vérifier que notre clé SSH est bien présente sur SRVLX01 :

```bash
ls -al ~/.ssh
```

![Screenshots](ressources/images/SRVLX01/ssh_key_present_SVRLX01.png)

Tapons cette commande pour l'installation de Keychain :

``` bash
sudo apt install -y keychain
```

Une fois installé il nous reste plus qu'a modifier le fichier de configuration de **keychain**.

Ouvrons le fichier de configuration à l'aide de cette commande :

``` bash
sudo nano ~/.bashrc
```
Ajoutons cette ligne à la fin du fichier :

		eval $(keychain --eval --quiet id_ed25519)


![Screenshots](ressources/images/SRVLX01/configuration_keychain.png)

### 2.6 Préparation du serveur Debian pour le script principal

#### Création de l'arborescence de dossiers
Le script principal bash nécessite une structure de dossiers spécifique. Créons là :

```bash
# Créer la structure de base
mkdir -p ~/Documents/TSSR-1025-P2-G1/scripts/info

# Vérifier la création
ls -la ~/Documents/TSSR-1025-P2-G1/scripts/
```

Cette structure est obligatoire car le script principal utilise les chemins suivants :
- **Scripts enfant :** `~/Documents/TSSR-1025-P2-G1/scripts/`
- **Fichiers d'informations rapatriés :** `~/Documents/TSSR-1025-P2-G1/scripts/info/`

#### Création et configuration du fichier de log
Ce dossier peut se créer automatiquement au lancement du script si il n'existe pas, mais nous pouvons la créer en amons.

```bash
# Créer le fichier de log
sudo touch /var/log/log_evt.log

# Donner les droits d'écriture
sudo chmod 666 /var/log/log_evt.log

# Vérifier les permissions
ls -l /var/log/log_evt.log
```
Les fichier devrait afficher : `-rw-rw-rw-` (permission 666)

#### Placement des scripts

```bash
# Placer le script principal
cp script_dady.sh ~/Documents/TSSR-1025-P2-G1/scripts/

# Rendre le script exécutable
chmod +x ~/Documents/TSSR-1025-P2-G1/scripts/script_dady.sh

# Copier tous les scripts enfants dans le même dossier
cp *.sh ~/Documents/TSSR-1025-P2-G1/scripts/
```

## 3. Installation sur le serveur Windows ( Windows serveur 2022 )

### 3.1 Installation OpenSSH-Client en GUI.

Dans la barre de recherche en bas de l'écran il nous faut inscrire 

	optional features

![Screenshots](ressources/images/SRVWIN01/optional_features.png)

Si **OpenSSH Client** n'est pas installer cliquer sur **Add a feature** pour procéder à l'installation.

### 3.2 Création d'une paire de clés Windows-Serveur

Pour générer la paire de clés voici la commande :

```bash
ssh-keygen -t ed25519 -C "wilder@srvwin_lab"
```
![Screenshots](ressources/images/SRVWIN01/creation_keys_srvwin01.png)
Remplir impérativement la **passphrase** ,cela seras le seul mot de passe à retenir pour toutes vos connexions sur vos serveurs possédant cette clé.

### 3.3 Copie de la clé Publique sur *CLIWIN01*

Pour copié la clé Publique sur *CLIWIN01* veuillez taper cette commande :

```bash
ssh wilder@CLIWIN01 "echo $(Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub) >> .ssh/authorized_keys"
```

### 3.4 Copie de la clé Publique sur *CLILIN01*

Pour copié la clé Publique sur *CLILIN01* veuillez taper cette commande :

```bash
ssh wilder@CLILIN01 "echo $(Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub) >> .ssh/authorized_keys"
```

### 3.5 Installation et activation de AGENT-SSH

Pour éviter de saisir la passphrase à chaque connexion SSH , il faut activer et configurer le ce service .
	- Ouvrir **PowerShell** en mode **Administrateur** et taper ses commandes :

```bash
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
```

Nous allons vérifier que le service est démarré avec cette commande :

```bash
Get-Service ssh-agent
```

Voici le résultat attendu :

![Screenshots](ressources/images/SRVWIN01/status_agentSHH.png)

Maintenant il faut ajouter la Clé Privé à l'agent :
	- Ouvrir **PowerShell** en mode normal et taper cette commande :

```bash
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

La Passphrase sera demander une seule fois,puis sera mémorisée.

Dernière étape on va vérifier que la clé est bien chargée avec cette commande :

```bash
ssh-add -l
```

Voici le résultat attendu :

![Screenshots](ressources/images/SRVWIN01/Key_private_SVRWIN01.png)

### 3.6 Configuration automatique au démarrage de PowerShell

Cette étape va servir à chargé automatiquement la clé Privé dans le SSH-Agent à chaque ouverture de PowerShell.

On va créé le fichier Profile avec cette commande :

```bash
New-Item -Path $PROFILE -ItemType File -Force
```

Voici le résultat attendu :

![Screenshots](ressources/images/SRVWIN01/Creation_file_profil_SVRWIN01.png)

Nous allons maintenant ouvrir ce fichier avec le Bloc note et ajouter cette ligne dans ce fichier :

		ssh-add $env:USERPROFILE\.ssh\id_ed25519

![Screenshots](ressources/images/SRVWIN01/Files_profile_SVRWIN01.png)

Maintenant à chaque redémarrage du serveur et à la 1ère ouverture de Powershell il va nous demander d'entrer notre Passphrase :

Une fois la Passphrase validé elle ne vous seras plus demandé jusqu'au prochain démarrage du serveur.

![Screenshot](ressources/images/SRVWIN01/Passphrase_SVRWIN01.png)

### 3.7 Préparation du serveur Windows pour le script principal
#### Installation du PowerShell Core 7.4

Le script PowerShell nécessite PowerShell Core version 7.4 ou supérieure.

Pour télécharger et installer PowerShell 7.4 :

1. Ouvrir PowerShell en mode **Administrateur**
2. Exécuter la commande suivante :

```powershell
# Télécharger et installer PowerShell 7.4
winget install --id Microsoft.Powershell --source winget
```

Ou télécharger manuellement depuis : https://github.com/PowerShell/PowerShell/releases

Vérifier la version installée :
```powershell
pwsh --version
```
#### Création et configuration du fichier de log
Ce dossier peut se créer automatiquement au lancement du script si il n'existe pas, mais nous pouvons la créer en amons.
```powershell
# Créer le fichier de log (nécessite PowerShell en Administrateur)
New-Item -Path "C:\Windows\System32\LogFiles\log_evt.log" -ItemType File -Force

# Vérifier la création
Test-Path "C:\Windows\System32\LogFiles\log_evt.log"
```

#### Placement des scripts

```powershell
# Placer le script principal
Copy-Item "script_momy.ps1" "$env:USERPROFILE\Documents\TSSR-1025-P2-G1\scripts\"

# Copier tous les scripts enfants dans le même dossier
Copy-Item "*.ps1" "$env:USERPROFILE\Documents\TSSR-1025-P2-G1\scripts\"
```

## 4. Installation sur le client Windows ( Windows 11 )
### 4.1 Installation Open SSH en CLI pour la connexion avec Debian

1. Ouvrir PowerShell en mode **administrateur**

```bash
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

2. Une fois l'installation terminé, il faut démarré le service :

```bash
Start-Service sshd
```

3. On configure le service pour qu'il démarre automatiquement

```bash
Set-Service -Name sshd -StartupType "Automatic"
```
Pour contrôler si le service sshd est activé , tapons cette commande :

```bash
Get-Service sshd
```

![Screenshots](ressources/images/CLIWIN01/status_sshd_CLIWIN01.png)

### 4.2 Modification du fichier de configuration *SSH*

Commencer par ouvrir **PowerShell** en tant qu'administrateur.

Ensuite ce rendre dans le dossier suivant :

```bash
notepad C:\ProgramData\ssh\sshd_config
```

Il faut dé-commenter cette ligne = Enlever le **#** devant pour l'activer

	PubkeyAuthentication yes

Il faut Commenter cette ligne = Ajouter un **#** devant pour la désactiver

	PasswordAuthentication yes

Nous devons également ajouter les lignes suivantes pour améliorer la sécurité :

		PermitRootlogin no
		AllowUSers wilder
		
Faire un **CTRL+S** pour sauvegarder le fichier après les modifications

Nous allons copier notre clé publique vers le fichiers des administrateur avec cette commande :

```bash
Copy-Item C:\Users\wilder\.ssh\authorized_keys C:\ProgramData\ssh\administrators_authorized_keys
```

Dernière étape mais très importante nous devons redémarrer le service **sshd** avec cette commande :

```bash
 Restart-Service sshd
```

Ensuite voici la commande pour tester la connexion *SSH* depuis Debian pour se connecter avec la **passphrase** sur windows :

```bash
ssh wilder@CLIWIN01
```

il me reste la sécurité des fichiers .ssh dans windows en graphique

### 4.3 Dossier d’informations pour les scripts enfants

Les scripts enfants stockent leurs informations dans le dossier :
`C:\Users\<user>\Documents\info`

Ce dossier est créé automatiquement lors de l’exécution des scripts enfants envoyés par le script principal.

**Vérification Manuelle** (optionnel) :

```powershell
# Créer le dossier manuellement si nécessaire
New-Item -Path "C:\Users\wilder\Documents\info" -ItemType Directory -Force
```

## 5. Installation sur le client Linux ( Ubuntu 24.04 LTS )

### 5.1 Installation de OpenSSH-server.

Nous devons exécuter les commandes suivantes pour l'installation :

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install openssh-server -y
sudo systemctl start ssh 
sudo systemctl enable ssh
```
Ensuite contrôlons le statut du service avec cette commande :

```bash
sudo systemctl status ssh
```
Nous devrions avoir l'affichage suivant : 

![screnshoot](ressources/images/CLILIN01/statut_ssh_clilin01.png)

### 5.2 Configuration du fichier de configuration SSH.

Exécutons cette commande pour nous rendre dans le fichier de configuration :

```bash
sudo nano /etc/ssh/sshd_config
```
Dans ce fichier nous devons ajouter les lignes suivantes pour améliorer la sécurité :

		PermitRootlogin no
		AllowUSers wilder

Il faut dé-commenter cette ligne = Enlever le **#** devant pour l'activer

		PubkeyAuthentication yes
		PasswordAutentication no

Faire un **CTRL+O** puis **ENTRER** pour sauvegarder et **CTRL+X** pour sortir du fichier après les modifications.	

Dernière étape mais très importante nous devons redémarrer le service **ssh** avec cette commande :

```bash
sudo systemctl restart ssh
```
Ensuite voici la commande pour tester la connexion *SSH* depuis Debian pour se connecter avec la **passphrase** sur CLILIN01 :

```bash
ssh wilder@CLILIN01
```
Nous devrions avoir cette affichage :

![Screnshoot](ressources/images/SRVLX01/connexion_ssh_keys_clilin01.png)

Maintenant nous allons exécuter ses deux commandes pour sécurisés l’accès a notre clé *Publique* :

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
Nous pouvons vérifié les droits avec cette commande :

```bash
ls -la ~/.ssh
```
Nous devrions avoir cette affichage :

![Screenshots](ressources/images/CLILIN01/permissions_files_ssh_clilin01.png)

### 5.3 Dossier d’informations pour les scripts enfants

Les scripts enfants stockent leurs informations dans le dossier :
`~/Documents/info`

Ce dossier est créé automatiquement lors de l’exécution des scripts enfants envoyés par le script principal.

**Vérification Manuelle** (optionnel) :

```powershell
# Créer le dossier manuellement si nécessaire
mkdir -p ~/Documents/info

# Vérifier la création
ls -ld ~/Documents/info
```

## 6. Vérification de la configuration

Une fois toutes les installations terminées, il est important de vérifier que tout fonctionne correctement.

### 6.1 Vérification de l'arborescence des dossiers

#### Sur SRVLX01 (Debian)

```bash
tree ~/Documents/TSSR-1025-P2-G1/
# Devrait afficher :
# ~/Documents/TSSR-1025-P2-G1/
# └── scripts/
#     ├── script_dady.sh
#     ├── [scripts enfants]
#     └── info/
```

#### Sur SRVWIN01 (Windows)

```powershell
tree /F $env:USERPROFILE\Documents\TSSR-1025-P2-G1\
# Devrait afficher :
# C:\Users\<utilisateur>\Documents\TSSR-1025-P2-G1\
# └── scripts\
#     ├── script_momy.ps1
#     ├── [scripts enfants]
#     └── info\
```

### 6.2 Vérification des fichiers de log

#### Sur SRVLX01 (Debian)

```bash
# Vérifier l'existence et les permissions
ls -l /var/log/log_evt.log

# Devrait afficher : -rw-rw-rw-
```

#### Sur SRVWIN01 (Windows)

```powershell
# Vérifier l'existence
Test-Path "C:\Windows\System32\LogFiles\log_evt.log"

# Devrait retourner : True
```

### 6.3 Test de rapatriement de fichiers

#### Depuis SRVLX01 vers CLILIN01

```bash
# Créer un fichier test sur CLILIN01
ssh wilder@CLILIN01 "echo 'test' > ~/Documents/info/test.txt"

# Rapatrier le fichier
scp wilder@CLILIN01:~/Documents/info/test.txt ~/Documents/TSSR-1025-P2-G1/scripts/info/

# Vérifier
ls ~/Documents/TSSR-1025-P2-G1/scripts/info/
```

#### Depuis SRVLX01 vers CLIWIN01

```bash
# Créer un fichier test sur CLIWIN01
ssh wilder@CLIWIN01 "powershell.exe -Command 'echo test > C:/Users/wilder/Documents/info/test.txt'"

# Rapatrier le fichier
scp wilder@CLIWIN01:C:/Users/wilder/Documents/info/test.txt ~/Documents/TSSR-1025-P2-G1/scripts/info/

# Vérifier
ls ~/Documents/TSSR-1025-P2-G1/scripts/info/
```


## 7. FAQ

### Questions générales

**Q : Le script ne trouve pas les scripts enfants.**  
**R :** Vérifier que tous les scripts enfants sont bien placés dans :
- Debian : `~/Documents/TSSR-1025-P2-G1/scripts/`
- Windows : `C:\Users\<utilisateur>\Documents\TSSR-1025-P2-G1\scripts\`

**Q : Aucun fichier n'a été rapatrié par le script principal, que faire ?**  
**R :** Vérifier que :
1. Le dossier d'informations existe sur la machine cliente :
   - Linux : `~/Documents/info/`
   - Windows : `C:\Users\wilder\Documents\info\`
2. Le script enfant a bien créé un fichier dans ce dossier
3. Les permissions SSH permettent le transfert de fichiers
4. Le dossier de destination existe sur le serveur : `~/Documents/TSSR-1025-P2-G1/scripts/info/`

**Q : Le fichier de log n'est pas créé.**  
**R :** S'assurer que :
- Debian : Le fichier `/var/log/log_evt.log` existe avec les bonnes permissions (666)
- Windows : Le fichier `C:\Windows\System32\LogFiles\log_evt.log` existe

### Questions SSH

**Q : SSH me renvoie "Permission denied".**  
**R :** Vérifier que :
1. La clé publique est bien installée dans `~/.ssh/authorized_keys`
2. L'utilisateur est autorisé dans la configuration sshd (`AllowUsers wilder`)
3. Les permissions de `~/.ssh/` sont correctes (700 pour le dossier, 600 pour les fichiers)
4. Le service sshd est bien démarré

**Q : Je dois entrer la passphrase à chaque connexion SSH.**  
**R :** Vérifier que :
- Debian : Keychain est bien installé et configuré dans `~/.bashrc`
- Windows : Le service ssh-agent est démarré et la clé est chargée (`ssh-add -l`)

**Q : La connexion SSH fonctionne en mot de passe mais pas avec la clé.**  
**R :** Vérifier que :
1. `PubkeyAuthentication yes` est décommenté dans `/etc/ssh/sshd_config`
2. Le service sshd a été redémarré après modification
3. La clé privée correspond bien à la clé publique installée

### Questions Windows spécifiques

**Q : Le script PowerShell ne veut pas se lancer.**  
**R :** Vérifier que :
1. PowerShell Core 7.4 (ou supérieur) est installé
2. La politique d'exécution permet le lancement : `Set-ExecutionPolicy RemoteSigned`

**Q : Impossible d'exécuter des commandes sur Windows depuis SSH.**  
**R :** S'assurer que :
1. OpenSSH Server est bien installé sur la machine Windows cible
2. Le service sshd est démarré et en mode automatique
3. Le pare-feu autorise les connexions SSH (port 22)

### Questions Linux spécifiques

**Q : Impossible de se connecter en SSH sur Ubuntu.**  
**R :** Vérifier que :
1. openssh-server est installé : `sudo apt install openssh-server`
2. Le service ssh est actif : `sudo systemctl status ssh`
3. Le fichier `/etc/ssh/sshd_config` est bien configuré

**Q : Les scripts enfants ne s'exécutent pas sur Linux.**  
**R :** S'assurer que :
1. Les scripts sont exécutables : `chmod +x script.sh`
2. Le shebang est correct : `#!/bin/bash` en première ligne
3. Les commandes sudo ne demandent pas de mot de passe (si nécessaire)

### Questions réseau

**Q : Impossible de pinguer les machines.**  
**R :** Vérifier que :
1. Toutes les machines sont sur le même réseau (172.16.10.0/24)
2. La passerelle par défaut est correcte (172.16.10.254)
3. Le DNS est configuré (8.8.8.8)
4. Le pare-feu n'empêche pas la communication

**Q : Le transfert de fichiers par scp échoue.**  
**R :** S'assurer que :
1. La connexion SSH fonctionne sans mot de passe (avec clé)
2. Les chemins source et destination sont corrects
3. L'utilisateur a les permissions d'écriture sur le dossier de destination

