FROM python:3.8-slim
ENV LANG C.UTF-8

RUN apt-get update && apt-get upgrade -qy && \
  apt-get install -qy \
    clang \
    clang-tools \
    gcc-multilib \
    gcc-arm-none-eabi \
    libc6-dev-armhf-cross \
    cmake \
    git \
    libudev-dev \
    libusb-1.0-0-dev \
    python3-pip \
    wget \
    lcov && \
  apt-get clean

RUN pip3 install ledgerblue pytest

# CMocka
RUN \
  echo f0ccd8242d55e2fd74b16ba518359151f6f8383ff8aef4976e48393f77bba8b6 cmocka-1.1.5.tar.xz >> SHA256SUMS && \
  wget https://cmocka.org/files/1.1/cmocka-1.1.5.tar.xz && \
  sha256sum --check SHA256SUMS && \
  mkdir cmocka && \
  tar xf cmocka-1.1.5.tar.xz && \
  cd cmocka && \
  cmake ../cmocka-1.1.5 -DBUILD_SHARED_LIBS=OFF -DWITH_EXAMPLES=OFF -DCMAKE_C_COMPILER=arm-none-eabi-gcc -DCMAKE_C_FLAGS="--specs=nosys.specs" -DWITH_STATIC_LIB=true -DCMAKE_INSTALL_PREFIX=/install && \
  make install && \
  cd .. && \
  rm -rf cmoka/ cmocka-1.1.5/ cmocka-1.1.5.tar.xz SHA256SUMS

# Nano S SDK
RUN git clone --branch nanos-160 https://github.com/LedgerHQ/nanos-secure-sdk.git sdk

ENV BOLOS_SDK=/sdk

WORKDIR /app

CMD ["/bin/bash"]
