FROM alpine:latest AS builder

LABEL maintainer="nbadger@mintel.com"

ENV JSONNET_VERSION="0.12.1"

RUN set -e \
    && apk add -U --no-cache build-base libstdc++ curl  \
    && curl -L https://github.com/google/jsonnet/archive/v$JSONNET_VERSION.tar.gz -o /tmp/jsonnet.tar.gz \
    && echo "257c6de988f746cc90486d9d0fbd49826832b7a2f0dbdb60a515cc8a2596c950 */tmp/jsonnet.tar.gz" | sha256sum -c \
    && tar zxvf /tmp/jsonnet.tar.gz  -C /tmp \
    && cd /tmp/jsonnet-$JSONNET_VERSION && make OPT="-static" && mv jsonnet /usr/local/bin && chmod a+x /usr/local/bin/jsonnet \
    && rm -rf /tmp/jsonnet.tar.gz /tmp/jsonnet-$JSONNET_VERSION \
    && apk del build-base libstdc++ curl

ENTRYPOINT ["/usr/local/bin/jsonnet"]
