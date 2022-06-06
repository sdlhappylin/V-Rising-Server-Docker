#!/bin/bash
USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}
cp /vrising/.wine/drive_c/VRisingServer/VRisingServer_Data/StreamingAssets/Settings /vrising/.wine/drive_c/VRisingServer/server-data
groupadd -g ${GROUP_ID} vrising && \
    useradd -m -s /bin/false -u ${USER_ID} -g ${GROUP_ID} vrising && \
    chmod -R 777 /vrising/.wine/drive_c/VRisingServer && \
    chown -R vrising:vrising /vrising/.wine/drive_c/VRisingServer/server-data

exec gosu vrising "$@"
