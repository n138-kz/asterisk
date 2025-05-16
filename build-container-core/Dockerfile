FROM ubuntu:24.04
WORKDIR /tmp

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
RUN apt-get install -y make

RUN if [ ! -d /usr/local/src ]; then mkdir -p /usr/local/src; fi

# Install libsrtp
RUN wget -O - https://github.com/cisco/libsrtp/archive/v2.7.0.tar.gz | tar zx -C /usr/local/src \
  && cd /usr/local/src/libsrtp-2.7.0 \
  && ./configure --prefix=/usr/local/libsrtp --enable-openssl \
  && make \
  && make install \
  && rm -rf /usr/local/src/libsrtp-2.7.0
