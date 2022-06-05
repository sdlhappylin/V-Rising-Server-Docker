FROM fragsoc/steamcmd-wine-xvfb

USER root
WORKDIR /
RUN DEBIAN_FRONTEND=noninteractive apt-get update  && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends --no-install-suggests gosu winbind -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean autoclean -y && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENV HOME="/vrising"
RUN mkdir -p /vrising/.wine/drive_c/VRisingServer/server-data
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
ENTRYPOINT ["/bin/bash", "/usr/local/bin/docker-entrypoint.sh"]
EXPOSE 9876/tcp 9876/udp 9877/tcp 9877/udp
CMD ["tini", "--", "xvfb-run", "-a", "wine", "./VRisingServer.exe", "-persistentDataPath", "./server-data"]
