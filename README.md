# VRising Dedicated Server Linux Docker
Run a VRising Dedicated Server on Linux via Docker

1.  
```
git clone https://github.com/smb1982/VRising-Dedicated-Server-Linux-Docker.git
```
2.  
```
cd VRising-Dedicated-Server-Linux-Docker/
```
3.
```
chmod +x ./* -R
```
4. 
```
./runServer.sh
```

Now this will probably take a few minutes as it will;

  * Build the base docker image (10-20 mins)
  * Download the VRising Dedicated Server from Steam (~1.6GB)
  * Run the Dedicated Server for the first time (usually 5-10 minutes)

## I would recommend shutting it down after it starts (You won't be able to connect yet anyway)!

Edit this file for Server Settings:
```
./VRising-Dedicated-Server-Linux-Docker/data/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json
```
At least change the Name, Port and QueryPort to match our Docker Ports (So outside can connect), and Port forward them.

    "Name": "YOURNAME V Rising Server [Linux Dedicated]",
    "Port": 27015,
    "QueryPort": 27016,



 Edit this file for the actual Game Settings:
 ```
 ./VRising-Dedicated-Server-Linux-Docker/data/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json
 ```


 Once you're happy, simply run;
 
 ```
 ./VRising-Dedicated-Server-Linux-Docker/runServer.sh
 ```
 
 And get to Vampirising! (The script will always make sure the server is up to date before running it!)
 
 ---
 
 Credits;
 
 This Server uses the following Images;
 
 maloneweb/docker-wine-base:latest
 honestventures/steamcmd-linux-wine:latest
 
