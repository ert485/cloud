#!/bin/bash

# ----------------
# Set variables
# ----------------

CLOUD_INSTALL="$HOME"
CLOUD_HOME="$HOME"
USERNAME="root"
<<<<<<< HEAD
PASSWORD="be4qaxe" # not secure, change passwords after
=======
PASSWORD="bE4pqxe" # not secure, change passwords after
>>>>>>> 7d209ef9c9794e84898fdc825ea2fdb0d340a42a


PROJECT_NAME="project"
LARAVEL_DIR="$CLOUD_HOME/$PROJECT_NAME"
MYSQL_DATABASE=$PROJECT_NAME
MYSQL_PASS=$PASSWORD
DOMAIN_NAME="domain.com"
ADMIN_EMAIL="email@mail.com"
GIT_URL="https://github.com/user/repo"


# ----------------
# Run commands
# ----------------

enableSwap

sudo apt update
cloud9
golang
theia

# installMysql
# installApache2
# setApacheConf
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

