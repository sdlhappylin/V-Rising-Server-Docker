FROM steamcmd/steamcmd:ubuntu-20 as builder
ARG DEBIAN_FRONTEND=noninteractive
ARG WINE_MONO_VERSION="4.7.3"
ARG WINEPREFIX=/root/.wine
ARG WINEARCH=win64
USER root
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
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
RUN apt update -yq && \
    apt install -y --no-install-recommends \
        winehq-stable
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/local/bin/winetricks \
    && chmod +x /usr/local/bin/winetricks \
    && chmod +x /usr/local/bin/*.sh \
    # Mono For Wine
    && mkdir /tmp/wine-mono \
    && wget https://dl.winehq.org/wine/wine-mono/${WINE_MONO_VERSION}/wine-mono-${WINE_MONO_VERSION}.msi -O /tmp/wine-mono/wine-mono-${WINE_MONO_VERSION} \ 
    # Install .NET Framework 2.0 and 4.6.2
    && wine wineboot --init \
    && waitforprocess.sh wineserver \
    && x11-start.sh \
    && winetricks --unattended --force vcrun2019 dotnet20 dotnet35 dotnet40 dotnet45 msxml6 dotnet_verifier
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
ENTRYPOINT["tini", "--"]
CMD ["xvfb-run", "-a", "wine", "./VRisingServer.exe", "-persistentDataPath", "./server-data", "-logFile", "/vrising/.wine/drive_c/VRisingServer/server-data/VRisingServer.log"]
