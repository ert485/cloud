#!/bin/bash

# if $1 is empty, put value $2 into variable described in $1
function setDefault(){
  if [ -z ${!1} ];then
    eval ${1}=$2
  fi
}

cloud9(){
	installDir="$CLOUD_INSTALL/c9sdk"
	workingDir="$CLOUD_HOME"
	port="$1"
	ip="0.0.0.0"
	username="$USERNAME"
	password="$PASSWORD"

	setDefault "port" "8181"

	mkdir -p $installDir
	sudo apt install -y build-essential python2.7 nodejs nodejs-legacy
	git clone git://github.com/c9/core.git $installDir
	"$installDir/"scripts/install-sdk.sh
	sudo ufw allow "$port"/tcp
	nohup node "$installDir/"server.js -p "$port" -l "$ip" -w "$workingDir" -a "$username:$password" &
}
