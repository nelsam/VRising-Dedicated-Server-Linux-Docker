#!/bin/bash

set -e

version=v20220523
appID=1829350
rconPort=${VRISING_SERVER_RCON_PORT:-27015}
gamePort=${VRISING_SERVER_GAME_PORT:-27016}
image=${VRISING_SERVER_IMAGE:-vrisingdedserver/wine64}

if [ ! -e data ]
then
    mkdir data
    chmod g+s data
    mkdir data/save-data
fi

if ! docker image inspect ${image}:${version} 2>&1 >/dev/null
then
    if ! docker pull ${image}:${version}
    then
        echo "could not pull image, building..."
        docker build . -t ${image}:${version}
    fi
fi

docker run --interactive --tty --rm --user $(id -u):$(id -g) \
    --name "VRisingUpdater" \
    --volume $PWD/data:/data \
    honestventures/steamcmd-linux-wine:latest \
    +force_install_dir /data \
    +login anonymous \
    +app_update ${appID} validate \
    +quit

cp data/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json data/save-data/ServerHostSettings.json
cp data/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json data/save-data/ServerGameSettings.json

docker run --interactive --tty --detach --rm --user $(id -u):$(id -g) \
    --name "VRisingServer" \
    --volume $PWD/data:/data \
    --publish ${rconPort}:27015 \
    --publish ${gamePort}:27016 \
    --publish ${rconPort}:27015/udp \
    --publish ${gamePort}:27016/udp \
    ${image}:${version}
