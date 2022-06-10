#!/bin/bash
USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}
groupadd -g ${GROUP_ID} vrising && \
    useradd -m -s /bin/false -u ${USER_ID} -g ${GROUP_ID} vrising && \
    chown -R vrising:vrising /vrising/.wine/drive_c/VRisingServer

exec gosu vrising "$@"
