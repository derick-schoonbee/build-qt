FROM ubuntu:xenial
MAINTAINER Derick Schoonbee <derick.schoonbee@gmail.com>

RUN apt-get update && apt-get clean # 20130925

RUN apt-get install -y curl
RUN apt-get install -y s3cmd
RUN apt-get install -y gcc g++
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y make
RUN apt-get install -y git
RUN apt-get install -y qt5-default libqt5sql5-mysql
RUN apt-get install -y libqt5xmlpatterns5-dev qtscript5-dev libqt5svg5-dev qtdeclarative5-dev
