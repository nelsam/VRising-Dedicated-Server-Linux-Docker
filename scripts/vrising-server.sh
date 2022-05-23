#!/usr/bin/env bash

set -e

cd /data
/usr/bin/xvfb-run wine VRisingServer.exe -persistentDataPath ".save-data" -log
