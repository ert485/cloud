#!/bin/bash
[ -f yarn.lock ] || yarn
[ -d src-gen ] || yarn theia build
yarn theia start /root