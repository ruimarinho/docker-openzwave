FROM alpine:latest

ENV OPENZWAVE_VERSION=1dba140b190caaa9c603a05c919a6d9d0450d10c
ENV OPENZWAVE_CONTROL_PANEL_VERSION=bbbd461c5763faab4949b12da12901f2d6f00f48

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
    && sed -i 's/#LIBUSB := -ludev/LIBUSB := -ludev/' Makefile \
    && sed -i 's/#LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) -pthread $(LIBUSB) -lresolv/LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) -pthread $(LIBUSB) -lresolv/' Makefile \
    && sed -i 's/LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) -pthread $(LIBUSB) $(ARCH) -lresolv/#LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) -pthread $(LIBUSB) $(ARCH) -lresolv/' Makefile \
    && make \
    && ln -sd /root/open-zwave/config

EXPOSE 8090

WORKDIR /root/open-zwave-control-panel/

ENTRYPOINT ["/root/open-zwave-control-panel/ozwcp"]
