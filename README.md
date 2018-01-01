# Cloud
Cloud server startup scripts

## Running server setup (installs cloud9)

### vultr - use this setup script

	#!/bin/sh
	export HOME="/root"
	cd $HOME
	git clone https://github.com/ert485/cloud
	cd cloud
	. init.sh

### digital ocean - ssh in and run this:

	sudo apt install -y git
	git clone https://github.com/ert485/cloud
	cd cloud
	init.sh

## accessing cloud9:

Find the IP of your server <br>
Go to your_ip:8181 in any browser

## installing more features:

When you run `init.sh`, lines uncommented in `config.sh` will run functions defined in `function.sh` 