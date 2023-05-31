
FROM alpine:latest
# Set version label
LABEL maintainer="github.com/Gezzl"
LABEL repository="github.com/Gezzl/qBittorrent-Docker"
LABEL image="qBittorrent-nox"
LABEL OS="alpine/latest"
#environment
ENV TZ=Europe/Moscow
#install packages
RUN apk --no-cache add \
    qbittorrent-nox \
    tzdata \
    doas \ 
    curl 
#add user for runas
RUN adduser \
    -D \
    -H \
    -s /sbin/nologin \
    -u 1000 \
    qbtUser && \
    echo "permit nopass :root" >> "/etc/doas.d/doas.conf"
#add TZ and Folders
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    mkdir /config && \
    mkdir /downloads && \
    chown qbtUser:qbtUser -R /config && \
    chown qbtUser:qbtUser -R /downloads 
#copy entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
#Expose Ports:
EXPOSE 8080/tcp 43936/tcp 43936/udp
#healtcheck
HEALTHCHECK --interval=5s --timeout=2s --retries=20 CMD curl --connect-timeout 15 --silent --show-error --fail http://localhost:8080/ >/dev/null || exit 1
#ENTRYPOINT
ENTRYPOINT ["/bin/sh","/entrypoint.sh"]