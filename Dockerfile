FROM ubuntu:xenial
MAINTAINER Derick Schoonbee <derick.schoonbee@gmail.com>

RUN apt-get update && apt-get clean # 20190516
RUN apt-get install -y software-properties-common
RUN apt-get install -y s3cmd awscli
RUN apt-get install -y git curl jq python gcc g++ make cmake libcurl4-openssl-dev libssl-dev uuid-dev libpulse-dev zlib1g-dev
RUN add-apt-repository ppa:beineri/opt-qt-5.11.1-xenial && apt-get update && apt-get clean #
RUN apt-get install -y qt511-meta-minimal qt5-qmake
RUN ln -s /opt/qt511/bin/qt511-env.sh /etc/profile.d/qt511



