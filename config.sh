#!/bin/bash

# ----------------
# Set variables
# ----------------

CLOUD_INSTALL="$HOME"
CLOUD_HOME="$HOME"
USERNAME="root"
PASSWORD="bE4pqyx" # not secure, change passwords after


PROJECT_NAME="test"
LARAVEL_DIR="$CLOUD_HOME/$PROJECT_NAME"
MYSQL_DATABASE=$PROJECT_NAME
MYSQL_PASS=$PASSWORD
DOMAIN_NAME="mysite.com"

# ----------------
# Run commands
# ----------------

sudo apt update
cloud9

# installMysql
# service mysql stop # reduce memory used
# setApacheConf
# service apache2 stop # reduce memory used
# installPHPdependencies
# getComposer