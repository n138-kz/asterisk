FROM ubuntu:24.04
WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade && echo "apt upgraded at: $(date)($(date +%s))" > apt_upgraded.txt

RUN if [ ! -f apt_upgraded.txt ]; then exit 1; fi
RUN apt-get install -y wget

RUN if [ ! -d /usr/local/src ]; then mkdir -p /usr/local/src; fi
