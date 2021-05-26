FROM ubuntu:20.04
ENV LANG C.UTF-8

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -qy && \
    apt-get install -qy \
        clang \
        clang-tools \
        cmake \
        git \
        libbsd-dev \
        libcmocka0 \
        libcmocka-dev \
        make \
        python3 \
        python3-pip \
        wget && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean

# ARM Embedded Toolchain
RUN wget -O arm-toolchain.tar.bz2 "https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2?revision=108bd959-44bd-4619-9c19-26187abf5225&la=en&hash=E788CE92E5DFD64B2A8C246BBA91A249CB8E2D2D" && \
    echo fe0029de4f4ec43cf7008944e34ff8cc arm-toolchain.tar.bz2 > /tmp/arm-toolchain.md5 && \
    md5sum --check /tmp/arm-toolchain.md5 && rm /tmp/arm-toolchain.md5 && \
    tar xf arm-toolchain.tar.bz2 -C /opt && \
    rm arm-toolchain.tar.bz2

ENV PATH=/opt/gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH

RUN pip3 install ledgerblue pytest

# Nano S SDK
RUN cd /opt && git clone --branch 2.0.0-1 https://github.com/LedgerHQ/nanos-secure-sdk.git nanos-secure-sdk

ENV BOLOS_SDK=/opt/nanos-secure-sdk

WORKDIR /app

CMD ["/bin/bash"]
