FROM python:3.8-slim
ENV LANG C.UTF-8

RUN apt-get update && apt-get upgrade -qy

RUN apt-get install -qy \
  gcc-arm-linux-gnueabihf \
  linux-libc-dev \
  linux-libc-dev-armhf-cross \
  libc6-dev-armhf-cross \
  cmake \
  git \
  libudev-dev \
  libusb-1.0-0-dev \
  python3-pip \
  wget

RUN pip3 install ledgerblue

# Download CMocka
RUN \
  echo f0ccd8242d55e2fd74b16ba518359151f6f8383ff8aef4976e48393f77bba8b6 cmocka-1.1.5.tar.xz >> SHA256SUMS && \
  wget https://cmocka.org/files/1.1/cmocka-1.1.5.tar.xz && \
  sha256sum --check SHA256SUMS

# Build CMocka
RUN mkdir cmocka && \
  tar xf cmocka-1.1.5.tar.xz && \
  cd cmocka && \
  cmake ../cmocka-1.1.5 -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc -DCMAKE_C_FLAGS=-mthumb -DWITH_STATIC_LIB=true -DCMAKE_INSTALL_PREFIX=/install && \
  make install

RUN apt-get install -qy gcc-multilib g++-multilib

# Build Clang
RUN \
  mkdir /compilers && \
  wget https://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz -O clang+llvm.tar.xz && \
  tar xf clang+llvm.tar.xz && \
  mv clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04 /compilers/clang-arm-fropi

# Build GCC
RUN \
  wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/5_3-2016q1/gccarmnoneeabi532016q120160330linuxtar.bz2 -O gcc.tar.bz2 && \
  tar xf gcc.tar.bz2 && \
  mv gcc-arm-none-eabi-5_3-2016q1 /compilers

ENV BOLOS_ENV=/compilers

ENV PATH="/compilers/gcc-arm-none-eabi-5_3-2016q1/bin:/compilers/clang-arm-frompi/bin:${PATH}"

# Remove unnecessary files
RUN rm -rf \
  cmocka/ \
  cmocka-1.1.5/ \
  cmocka-1.1.5.tar.xz \
  SHA256SUMS \
  clang+llvm.tar.xz \
  gcc.tar.bz2

RUN apt-get clean && rm -rf /var/lib/apt/lists/

RUN git clone https://github.com/LedgerHQ/nanos-secure-sdk.git sdk
ENV BOLOS_SDK=/sdk

CMD ["/bin/bash"]
