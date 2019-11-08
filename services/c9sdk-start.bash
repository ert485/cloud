#!/bin/bash
[ -d /opt/c9sdk ] || git clone https://github.com/c9/core /opt/c9sdk
[ -f ~/.c9/installed ] || /opt/c9sdk/scripts/install-sdk.sh
~/.c9/node/bin/node /opt/c9sdk/server.js --collab -p 8181 -w /
