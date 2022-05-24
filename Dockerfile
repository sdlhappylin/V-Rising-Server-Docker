FROM fragsoc/steamcmd-wine-xvfb

USER root
WORKDIR /
RUN DEBIAN_FRONTEND=noninteractive apt-get update  && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends --no-install-suggests winbind -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean autoclean -y && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000

ENV HOME="/vrising"

RUN mkdir -p vrising/server-data && \
    groupadd -g $GID vrising && \
    useradd -m -s /bin/false -u $UID -g $GID vrising && \
    mkdir -p /vrising/.wine/drive_c/VRisingServer/server-data && \
    chmod -R 777 /vrising/.wine/drive_c/VRisingServer && \
    chown -R vrising:vrising /vrising

USER vrising

# Install Server
ARG APPID=1829350
ARG STEAM_BETAS
ARG STEAM_EPOCH
RUN ls -lha /vrising/.wine/drive_c/VRisingServer
RUN steamcmd \
        +force_install_dir /vrising/.wine/drive_c/VRisingServer \
        +login anonymous \
        +app_update $APPID $STEAM_BETAS validate \
        +app_update 1007 validate \
        +quit

WORKDIR /vrising/.wine/drive_c/VRisingServer
VOLUME /vrising/.wine/drive_c/VRisingServer/server-data
EXPOSE 9876/tcp 9876/udp 9877/tcp 9877/udp
ENTRYPOINT ["tini", "--", "xvfb-run", "-a", "wine", "./VRisingServer.exe", "-persistentDataPath", "./server-data"]
