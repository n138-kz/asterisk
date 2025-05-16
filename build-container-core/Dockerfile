FROM ubuntu:24.04
WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade && echo "apt upgraded at: $(date)($(date +%s))" > apt_upgraded.txt

RUN test ! -f apt_upgraded.txt && exit 1
