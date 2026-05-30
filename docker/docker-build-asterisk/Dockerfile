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
    tar xz -f asterisk-23.3.0.tar.gz

WORKDIR /usr/src/asterisk-23.3.0

# MP3サポートが必要な場合
RUN ./contrib/scripts/get_mp3_source.sh

# 設定とビルド
RUN ./configure --with-jansson-bundled --with-pjproject-bundled
RUN menuselect/menuselect --enable format_mp3 menuselect.makeopts
RUN make -j$(nproc) && make install && make samples

RUN groupadd -r asterisk && useradd -r -g asterisk asterisk
RUN chown -R asterisk:asterisk /etc/asterisk /var/log/asterisk /var/lib/asterisk /var/spool/asterisk /usr/lib/asterisk

CMD ["/usr/sbin/asterisk", "-f", "-U", "asterisk"]
# # asterisk -h
# Asterisk 23.3.0, Copyright (C) 1999 - 2025, Sangoma Technologies Corporation and others.
# Usage: asterisk [OPTIONS]
# Valid Options:
#    -V              Display version number and exit
#    -C <configfile> Use an alternate configuration file
#    -G <group>      Run as a group other than the caller
#    -U <user>       Run as a user other than the caller
#    -c              Provide console CLI
#    -d              Increase debugging (multiple d's = more debugging)
#    -f              Do not fork
#    -F              Always fork
#    -g              Dump core in case of a crash
#    -h              This help screen
#    -i              Initialize crypto keys at startup
#    -L <load>       Limit the maximum load average before rejecting new calls
#    -M <value>      Limit the maximum number of calls to the specified value
#    -m              Mute debugging and console output on the console
#    -n              Disable console colorization. Can be used only at startup.
#    -p              Run as pseudo-realtime thread
#    -q              Quiet mode (suppress output)
#    -r              Connect to Asterisk on this machine
#    -R              Same as -r, except attempt to reconnect if disconnected
#    -s <socket>     Connect to Asterisk via socket <socket> (only valid with -r)
#    -t              Record soundfiles in /var/tmp and move them where they
#                    belong after they are done
#    -T              Display the time in [Mmm dd hh:mm:ss] format for each line
#                    of output to the CLI. Cannot be used with remote console mode.
# 
#    -v              Increase verbosity (multiple v's = more verbose)
#    -x <cmd>        Execute command <cmd> (implies -r)
#    -X              Enable use of #exec in asterisk.conf
#    -W              Adjust terminal colors to compensate for a light background
