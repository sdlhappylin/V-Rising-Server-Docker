#!/bin/bash

chmod -R 777 /vrising/.wine/drive_c/VRisingServer
chown -R vrising:vrising /vrising/.wine/drive_c/VRisingServer/server-data
gosu vrising
tini -- xvfb-run -a "wine ./VRisingServer.exe -persistentDataPath ./server-data
