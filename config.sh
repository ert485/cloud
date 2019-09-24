#!/bin/bash

# ----------------
# Set variables
# ----------------

CLOUD_INSTALL="$HOME"
CLOUD_HOME="$HOME"
USERNAME="root"
PASSWORD="be4qaxe" # not secure, change passwords after


PROJECT_NAME="project"
LARAVEL_DIR="$CLOUD_HOME/$PROJECT_NAME"
MYSQL_DATABASE=$PROJECT_NAME
MYSQL_PASS=$PASSWORD
DOMAIN_NAME="domain.com"
ADMIN_EMAIL="email@mail.com"
GIT_URL="https://github.com/user/repo"
GIT_NAME="John Doe"
GIT_EMAIL=$ADMIN_EMAIL



# ----------------
# Run commands
# ----------------

enableSwap

sudo apt update
setupGit
cloud9Run
golangInstall
certbotConfig
theiaBuild
setTheiaApacheConf
service apache2 restart

# installMysql
# installApache2
# setLaravelApacheConf
# installPHPdependencies
# getComposer

# service apache2 stop      # reduce memory used
# service mysql stop        # reduce memory used
# laravelInstaller
# service apache2 restart
# service mysql restart

# newLaravel
# cloneLaravelGit

# service apache2 stop      # reduce memory used
# service mysql stop        # reduce memory used
# composerInstall
# service apache2 restart
# service mysql restart

# migrate

# addAuth

