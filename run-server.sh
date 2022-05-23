#!/bin/bash

set -e

version=v20220523
appID=1829350
rconPort=${VRISING_SERVER_RCON_PORT:-27015}
gamePort=${VRISING_SERVER_GAME_PORT:-27016}
image=${VRISING_SERVER_IMAGE:-vrisingdedserver/wine64}
cfgDir=${VRISING_SERVER_CONFIG_DIR:-data/save-data}

## writeCfg writes a user's config to the game config directory. This has to be
## done every time we validate files because the game will overwrite any
## customizations that have been made.
writeCfg() {
    dataDir="data/VRisingServer_Data/StreamingAssets/Settings"
    cfgFile="${1}"
    if [ -e "${cfgDir}/${cfgFile}" ]
    then
        cp "${cfgDir}/${cfgFile}" "${dataDir}/${cfgFile}"
    fi
}

## syncConfig syncs back a server's config to the user's config directory. Most
## of the time, the file won't have changed; but it's better to be safe.
syncCfg() {
    dataDir="data/VRisingServer_Data/StreamingAssets/Settings"
    cfgFile="${1}"
    cp "${dataDir}/${cfgFile}" "${cfgDir}/${cfgFile}"
}

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

hostCfg="ServerHostSettings.json"
gameCfg="ServerGameSettings.json"

docker run --interactive --tty --rm --user $(id -u):$(id -g) \
    --name "VRisingUpdater" \
    --volume $PWD/data:/data \
    honestventures/steamcmd-linux-wine:latest \
    +force_install_dir /data \
    +login anonymous \
    +app_update ${appID} validate \
    +quit

writeCfg $hostCfg
writeCfg $gameCfg

docker run --interactive --tty --detach --rm --user $(id -u):$(id -g) \
    --name "VRisingServer" \
    --volume $PWD/data:/data \
    --publish ${rconPort}:27015 \
    --publish ${gamePort}:27016 \
    --publish ${rconPort}:27015/udp \
    --publish ${gamePort}:27016/udp \
    ${image}:${version}

syncCfg $hostCfg
syncCfg $gameCfg
