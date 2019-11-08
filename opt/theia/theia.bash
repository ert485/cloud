#!/bin/bash
cd /opt/theia
[ -f yarn.lock ] || yarn
[ -d src-gen ] || yarn theia build
yarn theia start /root
