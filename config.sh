#!/bin/bash

# ----------------
# Set variables
# ----------------

CLOUD_INSTALL="$HOME"
USERNAME="root"
PASSWORD=changetosecurepassword


PROJECT_NAME="project"
LARAVEL_DIR="$HOME/$PROJECT_NAME"
MYSQL_DATABASE=$PROJECT_NAME
MYSQL_PASS=$PASSWORD
BASE_DOMAIN="base.com"

SUBDOMAIN="w1"
DOMAIN_NAME=$SUBDOMAIN.$BASE_DOMAIN
ADMIN_EMAIL=mail@domain.com
GIT_URL="https://github.com/user/repo"
GIT_NAME="John Doe"
GIT_EMAIL=$ADMIN_EMAIL

GODADDY_AUTH="asdf:fdsa"
GODADDY_SHOPPER_ID="01234567"



# ----------------
# Run commands
# ----------------
putAllDNS
enableSwap

sudo apt update
setupGit
cloud9Run
certbotConfig
setC9ApacheConf
service apache2 restart
golangInstall
theiaBuild
setPasswords
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

