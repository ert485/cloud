#!/bin/bash

set -x

if [ -z "$BOOT_RUN" ];then
	. config.sh >> log.txt 2>&1
else
	. config_boot.sh >> log.txt 2>&1
fi

set +x
