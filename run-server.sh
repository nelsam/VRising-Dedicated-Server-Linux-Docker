#!/bin/bash

set -e

version=v20220523
appID=1829350
rconPort=${VRISING_SERVER_RCON_PORT:-27015}
gamePort=${VRISING_SERVER_GAME_PORT:-27016}

if [ ! -e data ]
then
    mkdir data
    chmod g+s data
    mkdir data/save-data
fi

if ! docker image inspect vrisingdedserver/wine64:${version} 2>&1 >/dev/null
then
    docker build . -t vrisingdedserver/wine64:${version}
fi

docker run --interactive --tty --rm \
    --name "VRisingUpdater" \
    --volume $PWD/data:/data \
    honestventures/steamcmd-linux-wine:latest \
    +force_install_dir /data \
    +login anonymous \
    +app_update ${appID} validate \
    +quit

cp data/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json data/save-data/ServerHostSettings.json
cp data/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json data/save-data/ServerGameSettings.json

docker run --interactive --tty --detach --rm \
    --name "VRisingServer" \
    --volume $PWD/data:/data \
    --publish ${rconPort}:27015 \
    --publish ${gamePort}:27016 \
    --publish ${rconPort}:27015/udp \
    --publish ${gamePort}:27016/udp \
    vrisingdedserver/wine64:${version}
