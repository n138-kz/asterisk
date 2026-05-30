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
    subversion \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-23.3.0.tar.gz && \
    tar xz -f asterisk-23.3.0.tar.gz && \
    rm asterisk-23.3.0.tar.gz && \
    ln -s asterisk-23.3.0 /usr/src/asterisk

WORKDIR /usr/src/asterisk

# MP3サポートが必要な場合
RUN ./contrib/scripts/get_mp3_source.sh

# 設定とビルド
RUN ./configure --with-jansson-bundled --with-pjproject-bundled
RUN make menuselect.makeopts
RUN menuselect/menuselect --enable format_mp3 menuselect.makeopts
RUN make -j$(nproc) && make install && make samples

RUN groupadd -r asterisk && useradd -r -g asterisk asterisk
RUN chown -R asterisk:asterisk /etc/asterisk /var/log/asterisk /var/lib/asterisk /var/spool/asterisk /usr/lib/asterisk

# 設定ディレクトリのバックアップ兼退避
RUN [ -d ./configs ] || mkdir ./configs
RUN mv /etc/asterisk/*.conf ./configs/
RUN cp /usr/src/asterisk/configs/samples/asterisk.conf /etc/asterisk/
RUN cp /usr/src/asterisk/configs/samples/modules.conf /etc/asterisk/
RUN cp /usr/src/asterisk/configs/samples/pjsip.conf /etc/asterisk/
RUN cp /usr/src/asterisk/configs/samples/extensions.conf /etc/asterisk/

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 5060/udp 5060/tcp 5061/tcp 5061/udp
EXPOSE 10000-20000/udp
ENTRYPOINT ["/entrypoint.sh"]
