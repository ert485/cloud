#!/bin/bash

# if $1 is empty, put value $2 into variable described in $1
setDefault(){
  if [ -z ${!1} ];then
    eval ${1}=$2
  fi
}

aptInstall(){
	apt install -y $1
}

putAllDNS(){
  externalIP=`curl ifconfig.me`
	putDNS $SUBDOMAIN $externalIP
	putDNS "c9.$SUBDOMAIN" $externalIP
	putDNS "th.$SUBDOMAIN" $externalIP
}

putDNS(){
	curl -X PUT \
	https://api.godaddy.com/v1/domains/$BASE_DOMAIN/records/A/$1 \
	-H 'Authorization: sso-key '$GODADDY_AUTH \
	-H 'Content-Type: application/json' \
	-H 'X-Shopper-Id: '$GODADDY_SHOPPER_ID \
	-H 'accept: application/json' \
	-d '[ { "data": "'$2'", "name": "'$1'", "priority": 0, "ttl": 1800, "type": "A" }]'
}

golangInstall(){
  aptInstall "golang"
  mkdir -p $HOME/go
  echo "export GOPATH=$HOME/go" >> $HOME/.bashrc
  echo "export GIT_TERMINAL_PROMPT=1" >> $HOME/.bashrc
  . $HOME/.bashrc
  aptInstall "gocode"
}

readOnlyFix(){
	install $CLOUD_INSTALL/cloud/services/readonlyfix.service /etc/systemd/system/
	systemctl enable readonlyfix
	systemctl start readonlyfix
}

cloud9Run(){
  which gcc || aptInstall build-essential
  which python || aptInstall python
  install $CLOUD_INSTALL/cloud/opt/c9/c9sdk.service /etc/systemd/system/
  install $CLOUD_INSTALL/cloud/opt/c9/c9sdk.bash /etc/systemd/system/
  systemctl enable c9sdk
  systemctl start c9sdk
}

setupGit(){
  git config --global user.name "$GIT_F_NAME $GIT_L_NAME"
  git config --global user.email $GIT_EMAIL
  git config --global credential.helper cache
}

certbotConfig(){
	externalIP=`curl ifconfig.me`
	apt-get install -y software-properties-common python-software-properties
	add-apt-repository -y ppa:certbot/certbot
	apt-get update
	apt-get install -y python-certbot-apache
	certbot --apache -d $DOMAIN_NAME -n --agree-tos --email $ADMIN_EMAIL --redirect
	certbot --apache -d th.$DOMAIN_NAME -n --agree-tos --email $ADMIN_EMAIL --redirect
	certbot --apache -d c9.$DOMAIN_NAME -n --agree-tos --email $ADMIN_EMAIL --redirect
}


theiaBuild(){
	installDir="$CLOUD_INSTALL/theia"
	mkdir -p $installDir
	sudo apt remove -y nodejs
	curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
	aptInstall "nodejs"
	aptInstall "pkg-config"
	aptInstall "libx11-dev libxkbfile-dev libxkbfile-dev"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update
  aptInstall yarn
	install $CLOUD_INSTALL/cloud/opt/theia/package.json $CLOUD_INSTALL/theia/
	install $CLOUD_INSTALL/cloud/opt/theia/theia.service /etc/systemd/system/
	install $CLOUD_INSTALL/cloud/opt/theia/theia.bash /etc/systemd/system/
  systemctl enable theia
  systemctl start theia
}

# gets php dependencies that are required for Laravel
function installPHPdependencies(){
  # add repo
    sudo add-apt-repository -y ppa:ondrej/php 
  # update repo
    sudo apt-get update
  # install php packages
    sudo apt-get install -y libapache2-mod-php7.1
    sudo apt-get install -y php7.1-dom
    sudo apt-get install -y php7.1-mbstring
    sudo apt-get install -y php7.1-zip
    sudo apt-get install -y php7.1-mysql 
} 

# Installs apache2
function installApache2(){
    apt update
    apt install -y apache2
}


function setC9ApacheConf(){
    c9Domain=c9.$DOMAIN_NAME
    newConfName="$c9Domain.conf"
    apacheSitesDir="/etc/apache2/sites-available"
    conf="$apacheSitesDir/$newConfName"
    echo '<VirtualHost *:80>'                 > $conf
    echo 'ServerName '$c9Domain                 >> $conf
    echo 'Redirect permanent / https://'$c9Domain'/'                 >> $conf
    echo '</VirtualHost>'                 >> $conf
    echo '<IfModule mod_ssl.c>'                 >> $conf
    echo -e "\t<VirtualHost *:443>"      >> $conf
    echo -e "\t\t<Location / >"                 >> $conf
    echo -e "\t\t\tAuthName \"Protected Area\""                 >> $conf
    echo -e "\t\t\tAuthType Basic"                 >> $conf
    echo -e "\t\t\tAuthUserFile /var/www/.htpasswd"                 >> $conf
    echo -e "\t\t\tRequire valid-user"                 >> $conf
    echo -e "\t\t</Location>"                 >> $conf
    echo -e "\t\tProxyPreserveHost On"                 >> $conf
    echo -e "\t\tProxyPass \"/\" \"http://localhost:8181/\""                 >> $conf
    echo -e "\t\tProxyPassReverse \"/\" \"http://localhost:8181/\""                 >> $conf
    echo -e "\t\tProxyRequests off"                 >> $conf
    echo -e "\t\tServerAdmin $ADMIN_EMAIL"                 >> $conf
    echo -e "\t\tServerName $c9Domain"  >> $conf
    echo -e "\t\tSSLCertificateFile /etc/letsencrypt/live/$c9Domain/fullchain.pem"                 >> $conf
    echo -e "\t\tSSLCertificateKeyFile /etc/letsencrypt/live/$c9Domain/privkey.pem"                 >> $conf
    echo -e "\t\tInclude /etc/letsencrypt/options-ssl-apache.conf"                 >> $conf
    echo -e "\t</VirtualHost>"                 >> $conf
    echo -e "</IfModule>"                 >> $conf
    mkdir -p /var/www/html
    sudo a2enmod proxy_http
    sudo a2enmod ssl
    sudo a2enmod proxy
    sudo a2ensite $newConfName
    sudo a2dissite 000-default-le-ssl.conf
    sudo a2dissite 000-default.conf
}
function setPasswords(){
	mkdir -p /var/www/html
	htpasswd -b -c /var/www/.htpasswd root $PASSWORD
	echo "root:$PASSWORD"|chpasswd
}
function setTheiaApacheConf(){
    theiaDomain=th.$DOMAIN_NAME
    newConfName="$theiaDomain.conf"
    apacheSitesDir="/etc/apache2/sites-available"
    conf="$apacheSitesDir/$newConfName"
    echo '<VirtualHost *:80>'                 > $conf
    echo 'ServerName '$theiaDomain                 >> $conf
    echo 'Redirect permanent / https://'$theiaDomain'/'                 >> $conf
    echo '</VirtualHost>'                 >> $conf
    echo '<IfModule mod_ssl.c>'                 >> $conf
    echo -e "\t<VirtualHost *:443>"      >> $conf
    echo -e "\t\t<Location / >"                 >> $conf
    echo -e "\t\t\tAuthName \"Protected Area\""                 >> $conf
    echo -e "\t\t\tAuthType Basic"                 >> $conf
    echo -e "\t\t\tAuthUserFile /var/www/.htpasswd"                 >> $conf
    echo -e "\t\t\tRequire valid-user"                 >> $conf
    echo -e "\t\t</Location>"                 >> $conf
    echo -e "\t\tRewriteEngine on"                 >> $conf
    echo -e "\t\tRewriteCond %{HTTP:Upgrade} websocket [NC]"                 >> $conf
    echo -e "\t\tRewriteCond %{HTTP:Connection} upgrade [NC]"                 >> $conf
    echo -e "\t\tRewriteRule .* \"ws://localhost:3000%{REQUEST_URI}\" [P]"                 >> $conf
    echo -e "\t\tProxyPreserveHost On"                 >> $conf
    echo -e "\t\tProxyPass \"/\" \"http://localhost:3000/\""                 >> $conf
    echo -e "\t\tProxyPassReverse \"/\" \"http://localhost:3000/\""                 >> $conf
    echo -e "\t\tProxyRequests off"                 >> $conf
    echo -e "\t\tServerAdmin $ADMIN_EMAIL"                 >> $conf
    echo -e "\t\tServerName $theiaDomain" >> $conf
    echo -e "\t\tSSLCertificateFile /etc/letsencrypt/live/$theiaDomain/fullchain.pem"                 >> $conf
    echo -e "\t\tSSLCertificateKeyFile /etc/letsencrypt/live/$theiaDomain/privkey.pem"                 >> $conf
    echo -e "\t\tInclude /etc/letsencrypt/options-ssl-apache.conf"                 >> $conf
    echo -e "\t</VirtualHost>"                 >> $conf
    echo -e "</IfModule>"                 >> $conf
    
    sudo a2enmod proxy_http
    sudo a2enmod rewrite
    sudo a2enmod ssl
    sudo a2enmod proxy
    sudo a2enmod proxy_wstunnel
    sudo a2ensite $newConfName
    sudo a2dissite 000-default-le-ssl.conf
    sudo a2dissite 000-default.conf
}

# sets apache configs to serve from the appropriate directory for laravel
function setLaravelApacheConf(){
    newConfName="$DOMAIN_NAME.conf"
    apacheSitesDir="/etc/apache2/sites-available"
    conf="$apacheSitesDir/$newConfName"
    newRoot="$LARAVEL_DIR/public"
    
    echo '<VirtualHost *:80>'                 > $conf
    echo -e "\tDocumentRoot" $newRoot         >> $conf
    echo -e "\tServerAdmin $ADMIN_EMAIL"      >> $conf
    echo -e "\tServerName $DOMAIN_NAME"       >> $conf
    echo -e "\tLogLevel info"                 >> $conf
    echo -e "\tErrorLog ${APACHE_LOG_DIR}/error.log" >> $conf
    echo -e "\tCustomLog ${APACHE_LOG_DIR}/access.log combined" >> $conf
    echo -e "\t" '<Directory' " $newRoot" '>' >> $conf
    echo -e "\t\tOptions Indexes FollowSymLinks" >> $conf
    echo -e "\t\tAllowOverride All\n\t\tRequire all granted" >> $conf
    echo -e "\t" '</Directory>'               >> $conf
    echo -e '</VirtualHost>'                  >> $conf
    
  #enable the site, disable default
    sudo a2dissite 000-default; sudo a2ensite $newConfName
    sudo a2enmod rewrite
}

# fix database bug (default string length)
# needs laravel 5.5 project present
function defaultStringLengthMod(){
    sed -i "N;N;/boot()\\n    {/a\\\t\\tSchema::defaultStringLength(191);" $LARAVEL_DIR/app/Providers/AppServiceProvider.php  
    sed -i "/use Illuminate\\\Support\\\ServiceProvider;/ause Illuminate\\\Support\\\Facades\\\Schema;" $LARAVEL_DIR/app/Providers/AppServiceProvider.php
}

# edit laravel environment config
# needs .env present in $LARAVEL_DIR
function envConfig(){
    sed -i "/DB_DATABASE=/c\DB_DATABASE=$MYSQL_DATABASE" $LARAVEL_DIR/.env
    sed -i "/DB_USERNAME=/c\DB_USERNAME=root" $LARAVEL_DIR/.env
    sed -i "/DB_PASSWORD=/c\DB_PASSWORD=$MYSQL_PASS" $LARAVEL_DIR/.env
    sed -i "/APP_NAME=/c\APP_NAME=$PROJECT_NAME" $LARAVEL_DIR/.env
    sed -i "/APP_URL=/c\APP_URL=http://$DOMAIN_NAME" $LARAVEL_DIR/.env
}

function installMysql(){
    # from https://gist.github.com/sheikhwaqas/9088872
    # Install MySQL Server in a Non-Interactive mode. Default root password will be $MYSQL_PASS
    echo "mysql-server mysql-server/root_password password $MYSQL_PASS" | sudo debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $MYSQL_PASS" | sudo debconf-set-selections 
    sudo apt-get -y install mysql-server
}

function getComposer(){
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
}

# needs mysql running
function addAuth(){
  cd $LARAVEL_DIR
  php artisan make:auth
}

# gets laravel installer
function laravelInstaller(){
    composer global require "laravel/installer"  
    PATH=~/.composer/vendor/bin:$PATH
    export PATH
}

# needs laravel installer
function newLaravel(){
    mkdir -p $LARAVEL_DIR
    cd $LARAVEL_DIR/..
    rm -rf $LARAVEL_DIR
    
    faketty () { script -qfc "$(printf "%q " "$@")"; }
    faketty laravel new $PROJECT_NAME
    
    chown -R www-data:www-data $LARAVEL_DIR/storage
    envConfig
    defaultStringLengthMod
}

# needs composer
function composerInstall(){
  cd $LARAVEL_DIR
  composer install --no-plugins --no-scripts
  php artisan key:generate
}

# needs php
function cloneLaravelGit(){
  mkdir -p $LARAVEL_DIR
  cd $LARAVEL_DIR/..
  git clone $GIT_URL $PROJECT_NAME
  chown -R www-data:www-data $LARAVEL_DIR
  cd $PROJECT_NAME
  cp .env.example .env
  envConfig
}

# needs mysql running
# needs php
function migrate(){
  mysql --user="root" --password="$MYSQL_PASS" --execute="create database $MYSQL_DATABASE"
  php artisan migrate:refresh --seed
}

function enableSwap(){
  install -c $CLOUD_INSTALL/cloud/services/enableswap.service /etc/systemd/system/
  install -c $CLOUD_INSTALL/cloud/services/enableswap.bash /etc/systemd/system/
  systemctl enable enableswap
  systemctl start enableswap
}
