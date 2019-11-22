FROM alpine:latest

ENV OPENZWAVE_VERSION=8d0684935389453fc26723306e7f2e453b7fa892
ENV OPENZWAVE_CONTROL_PANEL_VERSION=90e5fb18d8bab17aacc19ff6be8b0febc68fbac3

RUN apk --no-cache add \
      gnutls \
      gnutls-dev \
      libmicrohttpd \
      libusb \
      eudev \
    && apk --no-cache --virtual .build-dependencies add \
      coreutils \
      eudev-dev \
      g++ \
      gcc \
      git \
      libmicrohttpd-dev \
      libusb-dev \
      linux-headers \
      make \
      openssl \
    && cd /root \
    && git clone https://github.com/OpenZWave/open-zwave.git \
    && cd open-zwave \
    && git checkout ${OPENZWAVE_VERSION} \
    && make \
    && cd /root \
    && git clone https://github.com/OpenZWave/open-zwave-control-panel.git \
    && cd open-zwave-control-panel \
    && git checkout ${OPENZWAVE_CONTROL_PANEL_VERSION} \
    && make \
    && ln -sd /root/open-zwave/config

EXPOSE 8090

WORKDIR /root/open-zwave-control-panel/

ENTRYPOINT ["/root/open-zwave-control-panel/ozwcp"]
