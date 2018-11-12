#!/bin/bash

# ----------------
# Set variables
# ----------------

CLOUD_INSTALL="$HOME"
CLOUD_HOME="/var/www"
USERNAME="root"
PASSWORD="bE4pqxe" # not secure, change passwords after


PROJECT_NAME="timelapse-upload"
LARAVEL_DIR="$CLOUD_HOME/$PROJECT_NAME"
MYSQL_DATABASE=$PROJECT_NAME
MYSQL_PASS=$PASSWORD
DOMAIN_NAME="timelapse.eriktetland.com"
ADMIN_EMAIL="erik.tetland@gmail.com"
GIT_URL="https://github.com/ert485/timelapse-upload"


# ----------------
# Run commands
# ----------------

# enableSwap

# sudo apt update
# cloud9

# installMysql
installApache2
setApacheConf
installPHPdependencies
getComposer

service apache2 stop      # reduce memory used
# service mysql stop        # reduce memory used
laravelInstaller
# service apache2 restart
# service mysql restart

# newLaravel
cloneLaravelGit

# service apache2 stop      # reduce memory used
# service mysql stop        # reduce memory used
composerInstall
apt install -y ffmpeg
service apache2 restart
# service mysql restart

# migrate

# addAuth

