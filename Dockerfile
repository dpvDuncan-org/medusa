# see hooks/build and hooks/.config
ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}alpine

# see hooks/post_checkout
ARG ARCH
COPY .gitignore qemu-${ARCH}-static* /usr/bin/

# see hooks/build and hooks/.config
ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}alpine

# see hooks/post_checkout
ARG ARCH
COPY qemu-${ARCH}-static /usr/bin

RUN apk update && apk upgrade && \
    apk add --no-cache python3 ffmpeg mediainfo && \
    apk add --no-cache --virtual=.build-dependencies ca-certificates curl && \
    mkdir -p /opt/medusa && \
    curl -o /tmp/medusa.tar.gz -L "https://github.com/pymedusa/Medusa/archive/develop.tar.gz" && \
    tar xf /tmp/medusa.tar.gz -C /opt/medusa --strip-components=1 && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    ls -hal /opt/medusa && \
    chmod 777 /opt/medusa -R && \
    apk del .build-dependencies

# ports and volumes
EXPOSE 8081
VOLUME /config

CMD ["python3", "/opt/medusa/start.py", "--nolaunch", "--datadir", "/config"]

# annotation labels according to
# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title="Medusa"
LABEL org.opencontainers.image.description="Image to run Medusa"
LABEL org.opencontainers.image.url="https://github.com/dpvDuncan/medusa"
LABEL org.opencontainers.image.documentation="https://github.com/dpvDuncan/medusa#readme"
LABEL org.opencontainers.image.version="develop"
LABEL org.opencontainers.image.licenses=""
LABEL org.opencontainers.image.authors="dpvDuncan"