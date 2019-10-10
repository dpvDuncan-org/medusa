FROM alpine

RUN apk update && apk upgrade && \
    apk add --no-cache python3 ffmpeg mediainfo && \
    apk add --no-cache --virtual=.build-dependencies ca-certificates curl && \
    mkdir -p /opt/medusa && \
    curl -o /tmp/medusa.tar.gz -L "https://github.com/pymedusa/Medusa/archive/develop.tar.gz" && \
    tar xzvf /tmp/medusa.tar.gz -C /opt/medusa --strip-components=1 && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    ls -hal /opt/medusa && \
    chmod 777 /opt/medusa -R && \
    apk del .build-dependencies

# ports and volumes
EXPOSE 8081
VOLUME /config

CMD ["python3", "/opt/medusa/start.py", "--nolaunch", "--datadir", "/config"]
