# cloud
tools for cloud servers


## vultr - use this setup script

	#!/bin/sh

	export HOME="/root"

	cd $HOME

	BOOT_RUN="true"

	git clone https://github.com/ert485/cloud
	cd cloud
	. init.sh

	BOOT_RUN=""

## digital ocean - use this user-data

	#cloud-config

	runcmd:
	  - cd /root
	  - sudo apt install git
	  - git clone https://github.com/ert485/cloud
	  - cd cloud
	  - BOOT_RUN="true"
	  - . init.sh &
	  - BOOT_RUN=""