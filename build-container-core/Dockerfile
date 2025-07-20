FROM ubuntu:24.04
WORKDIR /tmp

ARG country_code
ARG asterisk_version
ARG ciscolibsrtp_version

RUN echo "::debug::\${country_code}: ${country_code}"
RUN echo "::debug::\${asterisk_version}: ${asterisk_version}"
RUN echo "::debug::\${ciscolibsrtp_version}: ${ciscolibsrtp_version}"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade && echo "apt upgraded at: $(date)($(date +%s))" > apt_upgraded.txt

RUN if [ ! -f apt_upgraded.txt ]; then exit 1; fi

RUN apt-get install -y locales && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8
ENV TZ=JST-9
ENV TERM=xterm
RUN apt-get install -y language-pack-ja-base language-pack-ja ibus-mozc && \
	update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

RUN apt-get install -y wget
RUN apt-get install -y make gcc
RUN apt-get install -y build-essential
RUN apt-get install -y gdb
RUN apt-get install -y libopus-dev
RUN apt-get install -y libopus0
RUN apt-get install -y libreadline-dev
RUN apt-get install -y libreadline8
RUN apt-get install -y libssl-dev
RUN apt-get install -y net-tools
RUN apt-get install -y opus-tools
RUN apt-get install -y postgresql-client
RUN apt-get install -y postgresql-client-common
RUN apt-get install -y sudo
RUN apt-get install -y unzip
RUN apt-get install -y zlib1g
RUN apt-get install -y zlib1g-dev

RUN if [ ! -d /usr/local/src ]; then mkdir -p /usr/local/src; fi

# Install libsrtp
RUN wget -O - https://github.com/cisco/libsrtp/archive/v2.7.0.tar.gz | tar zx -C /usr/local/src \
  && cd /usr/local/src/libsrtp-2.7.0 \
  && ./configure --prefix=/usr/local/libsrtp --enable-openssl \
  && make \
  && make install \
  && rm -rf /usr/local/src/libsrtp-2.7.0

# Install Asterisk
RUN wget -O - http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${asterisk_version}.tar.gz | tar zx -C /usr/local/src \
  && cd /usr/local/src/asterisk-${asterisk_version} \
  && sed -i 's/#define\ NUM_CACHE_BUCKETS\ 563/#define\ NUM_CACHE_BUCKETS\ 22520/g' ./main/stasis_cache.c \
  && sed -i 's/PJ_ICE_MAX_CAND\ 32/PJ_ICE_MAX_CAND\ 64/g' third-party/pjproject/patches/config_site.h \
  && echo "libvpb1 libvpb1/countrycode string ${country_code}" | debconf-set-selections \
  && yes | bash contrib/scripts/install_prereq install \
  && ./contrib/scripts/get_mp3_source.sh \
  && export PKG_CONFIG_PATH=/usr/lib/pkgconfig \
  && mkdir /usr/tmp -m 755 \
  && ./configure --prefix=/usr/local/asterisk --with-srtp=/usr/local/libsrtp --with-download-cache=/usr/tmp --with-srtp --with-ssl --with-crypto --with-jansson-bundled --with-pjproject-bundled --with-speex --with-opus \
  && make menuselect.makeopts \
  && menuselect/menuselect --enable format_mp3 --enable app_macro --enable codec_opus --enable REF_DEBUG --enable stereorize --enable streamplayer --enable CORE-SOUNDS-EN-WAV --disable CORE-SOUNDS-EN-GSM --enable CORE-SOUNDS-JA-WAV --enable CORE-SOUNDS-JA-WAV menuselect.makeopts \
  && make \
  && make install \
  && make config \
  && make samples \
  && rm -rf /usr/local/src/asterisk-${asterisk_version}

RUN useradd -U -m -s /bin/bash asterisk

RUN chown -R asterisk /usr/local/asterisk \
  && ln -s /usr/local/asterisk/sbin/asterisk /usr/bin/asterisk

ONBUILD COPY config/* /usr/local/asterisk/etc/asterisk/

USER asterisk
