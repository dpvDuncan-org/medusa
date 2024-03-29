# syntax=docker/dockerfile:1
ARG BASE_IMAGE_PREFIX

FROM ${BASE_IMAGE_PREFIX}alpine

ENV PUID=0
ENV PGID=0

COPY scripts/start.sh /

RUN apk -U --no-cache upgrade
RUN apk add --no-cache python3 ffmpeg mediainfo
RUN apk add --no-cache --virtual=.build-dependencies ca-certificates curl
RUN mkdir -p /opt/medusa
RUN curl -o - \
        -L "https://github.com/pymedusa/Medusa/archive/develop.tar.gz" \
        | tar xz -C /opt/medusa \
                --strip-components=1
RUN chmod -R 777 /start.sh /opt/medusa
RUN apk del .build-dependencies

RUN rm -rf /tmp/* /var/cache/apk/*

# ports and volumes
EXPOSE 8081
VOLUME /config

CMD ["/start.sh"]