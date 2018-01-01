#!/bin/bash

set -x
. config.sh >> log.txt 2>&1
echo "END" >> log.txt
set +x
