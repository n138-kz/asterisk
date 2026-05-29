FROM --platform=arm64 ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y \
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
    libavutil-dev

WORKDIR /usr/src
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-23.3.0.tar.gz && \
    tar xz -f asterisk-23.3.0.tar.gz

WORKDIR /usr/src/asterisk-23.3.0

# Install Asterisk prerequisites(プリリクイスト(前提条件)のインストール)
# Dockerにおいては、OSの apt で必要な -dev パッケージを先にインストールしておく方が、レイヤーのキャッシュ効率が良くなります。
# install_prereq はパッケージ名がOSごとに定義されているシェルスクリプトなので、トラブルシューティングや環境構築の初期段階での確認に使うのが適しています。
# RUN ./contrib/scripts/install_prereq install

# MP3サポートが必要な場合
RUN ./contrib/scripts/get_mp3_source.sh

# 設定とビルド
RUN ./configure --with-jansson-bundled --with-pjproject-bundled && \
    make -j$(nproc) && \
    make install && \
    make samples
