#!/bin/bash

mkdir logs
. functions.sh
echo "Running init..."
echo "See install progress at logs/log.txt"

set -x
. config.sh >> $LOG_DIR/install.log 2>&1
echo 'done' >> $LOG_DIR/install.log 2>&1
set +x

