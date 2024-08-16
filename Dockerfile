FROM debian:bullseye

ARG GODOT_VERSION=4.2.2-stable
ARG SCRIPT_AES256_ENCRYPTION_KEY=123
ARG GAME_ANALYTICS=false
RUN echo "Script key: $SCRIPT_AES256_ENCRYPTION_KEY"
RUN echo "Godot version to build: $GODOT_VERSION"

RUN apt-get update
RUN apt-get -y install git wget unzip

RUN wget https://github.com/godotengine/godot/archive/refs/tags/${GODOT_VERSION}.zip
RUN git clone https://github.com/obscurelyme/GA-SDK-GODOT
RUN unzip ${GODOT_VERSION}.zip
# RUN unzip v1.0.0.zip
# Copy GameAnalytics module into Godot's modules dir
# RUN cp -r ./GA-SDK-GODOT/gameanalytics ./godot-${GODOT_VERSION}/modules

RUN apt-get install -y \
  build-essential \
  pkg-config \
  libx11-dev \
  libxcursor-dev \
  libxinerama-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  libasound2-dev \
  libpulse-dev \
  libudev-dev \
  libxi-dev \
  libxrandr-dev \
  python3-full \
  python3-dev \
  python3-pip \
  python3-venv \
  mingw-w64 \
  openssl

RUN python3 -m venv zero && echo "source /zero/bin/activate" > ~/.bashrc
RUN ./zero/bin/pip install scons

# Swap mingw to posix thread model
RUN echo 1 | update-alternatives --config x86_64-w64-mingw32-gcc
RUN echo 1 | update-alternatives --config x86_64-w64-mingw32-g++

WORKDIR /godot-${GODOT_VERSION}

# Windows editor
RUN /zero/bin/scons platform=windows tools=yes bits=64 use_mingw=true target=editor arch=x86_64

# Windows export templates
RUN /zero/bin/scons platform=windows tools=no bits=64 use_mingw=true target=template_debug arch=x86_64
RUN /zero/bin/scons platform=windows tools=no bits=64 use_mingw=true target=template_release arch=x86_64

# Linux editor
RUN /zero/bin/scons platform=linuxbsd tools=yes bits=64 target=editor arch=x86_64

# Linux export templates
RUN /zero/bin/scons platform=linuxbsd tools=no bits=64 target=template_debug arch=x86_64
RUN /zero/bin/scons platform=linuxbsd tools=no bits=64 target=template_release arch=x86_64

# Copy libraries into /godot-4.2.2-stable/bin dir
# RUN mkdir -p ./bin
# Win64
# RUN cp ./modules/gameanalytics/cpp/lib/win64/GameAnalytics.dll ./bin
# Linux
# RUN cp ./modules/gameanalytics/cpp/lib/linux/libGameAnalytics.so ./bin