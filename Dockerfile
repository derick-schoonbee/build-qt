FROM derick/qt-base:latest
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
        build-essential \
        zip unzip p7zip vim \
        libglu1-mesa \
        libssl-dev zlib1g-dev libx11-dev libglib2.0-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev libz-dev \
        libmysqlclient-dev \
        s3cmd \
        git \
        libcurl4-openssl-dev \
        qtbase5-dev qtbase5-dev-tools qt5-qmake qt5-qmake-bin \
        qtdeclarative5-dev libqt5xmlpatterns5-dev qtbase5-private-dev \
    && apt-get clean