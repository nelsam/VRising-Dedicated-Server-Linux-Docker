#!/bin/bash
mkdir -p data
sudo docker build . -t vrisingdedserver/wine64:v20052022
sudo docker run --name "VRisingUpdater" --rm -it -v $PWD/data:/data honestventures/steamcmd-linux-wine:latest +force_install_dir /data +login anonymous +app_update 1829350 validate +quit
sudo docker run -it -d --name vRisingServer --rm -v $PWD/data:/data -p 10.1.1.111:27015:27015 -p 10.1.1.111:27016:27016 -p 10.1.1.111:27015:27015/udp -p 10.1.1.111:27016:27016/udp vrisingdedserver/wine64:v20052022 /bin/bash -c "cd /data; /usr/bin/xvfb-run wine VRisingServer.exe -persistentDataPath \".\save-data\" -log"