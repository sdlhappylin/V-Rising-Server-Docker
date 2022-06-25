FROM steamcmd/steamcmd:ubuntu-20 as builder
ARG DEBIAN_FRONTEND=noninteractive
ARG WINEARCH=win64
USER root
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
RUN apt update -yq && \
    apt install -y --no-install-recommends \
        wget \
        ca-certificates \
        software-properties-common \
        lsb-release \
        gnupg \
        curl \
        xvfb 
RUN wget -O- https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
RUN apt-add-repository "deb http://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main"
RUN dpkg --add-architecture i386 && \
    apt update -yq && \
    apt install -y --no-install-recommends winehq-stable
ADD https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks  /usr/local/bin/winetricks 
RUN chmod +x /usr/local/bin/winetricks 
   
FROM builder as runnner
ARG APPID=1829350
ARG STEAM_BETAS
ARG STEAM_EPOCH
RUN mkdir -p /root/.wine/drive_c/VRisingServer/server-data
RUN ls -lha /root/.wine/drive_c/VRisingServer
RUN steamcmd \
        +force_install_dir /root/.wine/drive_c/VRisingServer \
        +login anonymous \
        +app_update $APPID $STEAM_BETAS validate \
        +app_update 1007 validate \
        +quit

WORKDIR /root/.wine/drive_c/VRisingServer
VOLUME /root/.wine/drive_c/VRisingServer/server-data
ENTRYPOINT ["tini", "--"]
CMD ["xvfb-run", "-a", "wine", "./VRisingServer.exe", "-persistentDataPath", "./server-data", "-logFile", "/vrising/.wine/drive_c/VRisingServer/server-data/VRisingServer.log"]
