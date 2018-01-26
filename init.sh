#!/bin/bash

mkdir logs
LOG_DIR="$PWD/logs"
LOG_FILE="install.log"

. functions.sh
echo "Running init..."
echo "See install progress at $LOG_DIR/$LOG_FILE"

set -x
date -u >> $LOG_DIR/$LOG_FILE 2>&1
. config.sh >> $LOG_DIR/$LOG_FILE 2>&1
echo 'done' >> $LOG_DIR/$LOG_FILE 2>&1
set +x

