FROM ubuntu:bionic
MAINTAINER Derick Schoonbee <derick.schoonbee@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get clean # 20190516
RUN apt-get install -y software-properties-common
RUN apt-get install -y --no-install-recommends s3cmd curl wget openssl1.0
RUN apt-get install -y git jq python gcc g++ make cmake libssl1.0-dev libpulse-dev zlib1g-dev libgl1-mesa-dev
RUN add-apt-repository ppa:beineri/opt-qt-5.12.3-bionic && apt-get update && apt-get clean #
RUN apt-get install -y qt512-meta-minimal qt5-qmake
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 8C718D3B5072E1F5
RUN echo "deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-8.0" >> /etc/apt/sources.list.d/mysql.list
RUN apt-get update && apt-get install -y mysql-client libmysqlclient-dev

#RUN curl -sSL https://download.qt.io/archive/qt/5.12/5.12.3/submodules/qtbase-everywhere-src-5.12.3.tar.xz | tar xJ
RUN ln -s /opt/qt512/bin/qt512-env.sh /etc/profile.d/
ENV QT_BASE_DIR=/opt/qt512
ENV QTDIR="${QT_BASE_DIR}"
ENV PATH="${QT_BASE_DIR}/bin:${PATH}"
