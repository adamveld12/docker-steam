FROM debian:jessie

MAINTAINER Adam Veldhousen <adam@veldhousen.ninja>, @adamveld12

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install lib32gcc1 libstdc++6 libstdc++6:i386 curl ca-certificates tar


WORKDIR /home/steam

RUN mkdir -p /home/steam/steamcmd/ && \
    curl http://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C ./steamcmd/ && \
    echo quit | ./steamcmd/steamcmd.sh && \
    mkdir -p ./.steam/sdk32 && mkdir /configuration && mkdir /data && \
    ln -s /home/steam/steamcmd/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so

ENV STEAMUSER="anonymous"
ENV STEAMPASS=""

VOLUME  ["/configuration", "/data"]

COPY ./configuration/startup.sh /configuration
COPY ./install.sh .

ENTRYPOINT ./install.sh && /configuration/startup.sh
