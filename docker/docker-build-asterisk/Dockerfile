FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    tar \
    libncurses5-dev \
    libssl-dev \
    libxml2-dev \
    libsqlite3-dev \
    uuid-dev \
    libjansson-dev \
    libedit-dev \
    libspeex-dev \
    libspeexdsp-dev \
    libopus-dev \
    libavformat-dev \
    libavcodec-dev \
    libavutil-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-23.3.0.tar.gz && \
    tar xz -f asterisk-23.3.0.tar.gz

WORKDIR /usr/src/asterisk-23.3.0

# 設定とビルド
RUN ./configure --with-jansson-bundled --with-pjproject-bundled && \
    make -j$(nproc) && \
    make install && \
    make samples
