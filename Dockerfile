# Build stage 0: install the Qt installer dependencies
ARG UBUNTU=bionic
FROM ubuntu:${UBUNTU} as installerdeps
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
        ca-certificates \
        default-jdk \
        libfontconfig1 \
        libice6 \
        libsm6 \
        libx11-xcb1 \
        libxext6 \
        libxrender1 \
        p7zip \
        xvfb \
        xz-utils \
    && apt-get clean

# Build stage 1: run the Qt installer
FROM installerdeps as qtinstalled

# WARNING: these arguments below MUST be kept up to date by hand for builds
# on Docker Hub to work like they did on your machine, AND MUST match between
# all build stages. Look for them again further below.
ARG QT=5.12.0
ARG QTM=5.12
ARG QTSHA=5e644f8187718830075d3a563d8865d128d2fcfe5bac7315be104f752b508a7e
ARG QTCOMPONENTS=gcc_64
ARG DELETE="Docs Examples Tools MaintenanceTool"

# The rest can be left to the default:
ARG QTRUNFILE=http://download.qt.io/official_releases/qt/${QTM}/${QT}/qt-opensource-linux-x64-${QT}.run
ARG QTBASEFILE=http://download.qt.io/official_releases/qt/${QTM}/${QT}/submodules/qtbase-everywhere-src-${QT}.tar.xz
# Steps, kicking off from the tail end of installerdeps above:
ADD qt-installer-noninteractive.qs /tmp/qt/script.qs
ADD ${QTRUNFILE} /tmp/qt/installer.run
ENV QTM=$QTM
ENV QTSHA=$QTSHA
ENV QTCOMPONENTS=$QTCOMPONENTS
ENV DELETE=$DELETE
COPY ${QTBASEFILE} /tmp/

# use bash for RUN until the next FROM, so we can use bash strict mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
SHELL ["/bin/bash", "-c"]
RUN set -euo pipefail \
    && chmod +x /tmp/qt/installer.run \
    && xvfb-run -e /dev/stderr /tmp/qt/installer.run --script /tmp/qt/script.qs --verbose \
    && rm -rf /tmp/qt \
    && cd /opt/qt \
    && rm -rf ${DELETE}
RUN ls -l /tmp
RUN tar xJ -f /tmp/qtbase-everywhere-src-${QT}.tar.xz
RUN ls -l /opt/qt
RUN mv qtbase-everywhere-src-${QT} /opt/qt/${QT}/qtbase

# Build stage 2: copy Qt from the first stage, thus needing fewer packages
# and leaving less of a mess e.g. the build layer with /tmp/qt/installer.run
FROM ubuntu:${UBUNTU}

# WARNING: these arguments below MUST be kept up to date by hand for builds
# on Docker Hub to work like they did on your machine, AND MUST match between
# all build stages. Look for them again further above.
ARG QT=5.12.0
ARG QTM=5.12
ARG QTCOMPONENTS=gcc_64

# The rest can be left to the default:
ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.name="qt-build" \
      org.label-schema.description="A headless Qt $QTM build environment for Ubuntu" \
      org.label-schema.version="$QT" \
      org.label-schema.schema-version="1.0"

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
        locales \
        build-essential \
        p7zip \
        gnupg \
    && apt-get clean

#RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 8C718D3B5072E1F5
RUN echo "deb [trusted=yes] http://repo.mysql.com/apt/ubuntu/ bionic mysql-8.0" >> /etc/apt/sources.list.d/mysql.list
RUN apt-get update && apt-get install -y mysql-client libmysqlclient-dev

COPY --from=qtinstalled /opt/qt /opt/qt
RUN for COMPONENT in `echo ${QTCOMPONENTS} | tr , ' '`; do echo /opt/qt/${QT}/${COMPONENT}/lib >> /etc/ld.so.conf.d/qt-${QT}.conf; done
RUN locale-gen en_US.UTF-8 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV QTDIR=/opt/qt/${QT}
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/qt/${QT}/gcc_64/bin
RUN cd $QTDIR/qtbase/src/plugins/sqldrivers \
    && qmake -- MYSQL_PREFIX=/usr/local \
    && make sub-mysql \
    && cd mysql && make install
