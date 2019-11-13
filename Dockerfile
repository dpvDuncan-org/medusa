FROM multiarch/qemu-user-static as qemu

ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}alpine

COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/

RUN apk update && apk upgrade
RUN apk add --no-cache python3 ffmpeg mediainfo
RUN apk add --no-cache --virtual=.build-dependencies ca-certificates curl
RUN mkdir -p /opt/medusa
RUN curl -o - \
        -L "https://github.com/pymedusa/Medusa/archive/develop.tar.gz" \
        | tar xz -C /opt/medusa \
                --strip-components=1
RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN chmod 777 /opt/medusa -R
RUN apk del .build-dependencies

RUN rm -rf /usr/bin/qemu-*-static

# ports and volumes
EXPOSE 8081
VOLUME /config

CMD ["python3", "/opt/medusa/start.py", "--nolaunch", "--datadir", "/config"]