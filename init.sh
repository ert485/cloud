#!/bin/bash

. functions.sh
echo "Running init..."
echo "See install progress at log.txt"
. log.sh >/dev/null 2>&1 &
