FROM derick/qt-base:focal-5.15.0
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
        build-essential \
        python-magic python-dateutil \
        zip unzip p7zip vim \
        libglu1-mesa \
        libssl-dev zlib1g-dev libx11-dev libglib2.0-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev libz-dev \
        libmysqlclient-dev \
        qt515declarative qt515xmlpatterns \
    && apt-get clean
