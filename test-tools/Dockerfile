
#######################################################################
#                            DEPENDENCIES                             #
#######################################################################
FROM docker.io/library/python:3.10-slim AS dependencies

ARG TARGETARCH
ARG TARGETPLATFORM

RUN echo "Building for architecture: $TARGETARCH on platform: $TARGETPLATFORM."

ENV LANG=C.UTF-8

# hadolint ignore=DL3008
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends -qy \
    cmake \
    curl \
    gcc \
    gcc-arm-linux-gnueabihf \
    build-essential \
    git \
    libc6-dev-armhf-cross \
    libvncserver-dev \
    python3-pip \
    qemu-user-static \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# There are issues with PYTHONHOME if using distro packages, use pip instead.
# hadolint ignore=DL3013, DL3042
RUN pip3 install construct flake8 flask flask_restful jsonschema mnemonic pycrypto pyelftools pbkdf2 pytest Pillow requests

# Create SHA256SUMS, download dependencies and verify their integrity
RUN \
  echo 892a0875b9872acd04a9fde79b1f943075d5ea162415de3047c327df33fbaee5 openssl-1.1.1k.tar.gz >> SHA256SUMS && \
  echo f0ccd8242d55e2fd74b16ba518359151f6f8383ff8aef4976e48393f77bba8b6 cmocka-1.1.5.tar.xz >> SHA256SUMS && \
  echo 70127766f8031cde3df4224d88f7b33dec6c33fc7ac6b8e4308d4f7d0bdffd7b d0bc304a132df43856d8302e15dabee97d3d8a95.tar.gz && \
  wget --quiet https://www.openssl.org/source/openssl-1.1.1k.tar.gz && \
  wget --quiet https://cmocka.org/files/1.1/cmocka-1.1.5.tar.xz && \
  wget --quiet https://github.com/supranational/blst/archive/d0bc304a132df43856d8302e15dabee97d3d8a95.tar.gz && \
  sha256sum --check SHA256SUMS && \
  rm SHA256SUMS

# Build dependencies and install them in /install
# hadolint ignore=DL3003
RUN mkdir install && \
  tar xf openssl-1.1.1k.tar.gz && \
  cd openssl-1.1.1k && \
  ./Configure --cross-compile-prefix=arm-linux-gnueabihf- no-asm no-threads no-shared no-sock linux-armv4 --prefix=/install && \
  make -j4 CFLAGS=-mthumb && \
  make install_sw && \
  cd .. && \
  rm -r openssl-1.1.1k/ openssl-1.1.1k.tar.gz

# hadolint ignore=DL3003
RUN mkdir cmocka && \
  tar xf cmocka-1.1.5.tar.xz && \
  cd cmocka && \
  cmake ../cmocka-1.1.5 -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc -DCMAKE_C_FLAGS=-mthumb -DWITH_STATIC_LIB=true -DCMAKE_INSTALL_PREFIX=/install && \
  make install && \
  cd .. && \
  rm -r cmocka/ cmocka-1.1.5/ cmocka-1.1.5.tar.xz

# Build blst library (BLS12-381 signature library)
# hadolint ignore=DL3003
RUN tar xf d0bc304a132df43856d8302e15dabee97d3d8a95.tar.gz && \
  cd blst-d0bc304a132df43856d8302e15dabee97d3d8a95 && \
  sh build.sh CC=arm-linux-gnueabihf-gcc && \
  cp libblst.a ../install/lib/ && \
  cp bindings/blst.h ../install/include/ && \
  cp bindings/blst_aux.h ../install/include/ && \
  cd .. && \
  rm -r blst-d0bc304a132df43856d8302e15dabee97d3d8a95/ d0bc304a132df43856d8302e15dabee97d3d8a95.tar.gz

#######################################################################
#                            BUILDER IMAGE                            #
#######################################################################
FROM dependencies AS builder

ARG SPECULOS_VERSION
RUN echo "Speculos version: $SPECULOS_VERSION"

# hadolint ignore=DL3003
RUN git clone --branch ${SPECULOS_VERSION} --depth 1 https://github.com/LedgerHQ/speculos.git && \
    cd speculos && \
    cmake -Bbuild -H. -DPRECOMPILED_DEPENDENCIES_DIR=/install -DWITH_VNC=1 && \
    make -C build

#######################################################################
#                             FINAL IMAGE                             #
#######################################################################
FROM python:3.10-slim AS final

ARG SPECULOS_VERSION
RUN echo "Speculos version: $SPECULOS_VERSION"

# hadolint ignore=DL3003,DL3008,DL3015
RUN apt-get update && apt-get install -q -y \
    qemu-user-static \
    libvncserver-dev \
    gdb-multiarch \
    binutils-arm-none-eabi \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git clone  https://github.com/LedgerHQ/speculos.git && cd speculos && git checkout ${SPECULOS_VERSION}

WORKDIR /speculos/speculos

COPY --from=builder /speculos/speculos/resources/ /speculos/speculos/resources/

# hadolint ignore=DL3013
RUN pip install --no-cache-dir --upgrade pip pipenv && \
    pipenv install --system --deploy

RUN apt-get clean && rm -rf /var/lib/apt/lists/

# default port for dev env
EXPOSE 1234
EXPOSE 1236
EXPOSE 9999
EXPOSE 40000
EXPOSE 41000
EXPOSE 42000

ENTRYPOINT [ "python", "./speculos.py" ]
