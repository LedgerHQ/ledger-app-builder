FROM alpine:3.15
ENV LANG C.UTF-8

RUN apk update
RUN apk upgrade

# Adding LLVM-15 APT repository and installing it
# LLVM-15 is only present starting from the v3.17 Alpine version
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/v3.17/main llvm15
RUN ln -s /usr/lib/llvm15/bin/llvm-objcopy /usr/bin/llvm-objcopy-15
RUN ln -s /usr/lib/llvm15/bin/llvm-nm /usr/bin/llvm-nm-15

RUN apk add \
        bash \
        clang \
        clang-analyzer \
        clang-extra-tools \
        cmake \
        cmocka-dev \
        doxygen \
        gcc-arm-none-eabi \
        git \
        jq \
        lld \
        make \
        musl-dev \
        newlib-arm-none-eabi \
        protoc \
        python3

# Install pip and wheel
RUN python3 -m ensurepip --upgrade \
    && pip3 install --upgrade pip \
    && pip3 install wheel

# lcov is only present in the community repository of the edge branch but its perl-json-xs
# dependency won't work on 3.15 so install it (from the 3.15 repo) first
RUN apk add perl-json-xs && \
    apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community lcov

# This package is required by lcov (but somehow not listed as such in the Alpine package)
RUN apk add gzip

# So that it still supports things incorrectly pointing to python
RUN ln -s python3 $(dirname $(which python3))/python

# These packages contain shared libraries which will be needed at runtime
RUN apk add \
        eudev \
        libjpeg \
        libusb \
        zlib

# Python packages building dependencies, can be removed afterwards
RUN apk add -t python_build_deps eudev-dev \
                                 jpeg-dev \
                                 libusb-dev \
                                 linux-headers \
                                 python3-dev \
                                 zlib-dev

# temporary, until a fixed version of hidapi is released (with https://github.com/trezor/cython-hidapi/commit/749da69)
RUN pip3 install 'Cython<3'

# Python package to load app onto device
RUN pip3 install "ledgerblue==0.1.54" tomli-w

ARG GIT_SERVER=https://github.com/LedgerHQ

# Unified SDK
ENV LEDGER_SECURE_SDK=/opt/ledger-secure-sdk
RUN git clone "$GIT_SERVER/ledger-secure-sdk.git" "$LEDGER_SECURE_SDK"

# Latest Nano S SDK (OS nanos_2.1.0 => based on API_LEVEL LNS)
ENV NANOS_SDK=/opt/nanos-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOS_SDK" lns-2.1.0-v22.1
RUN echo nanos > $NANOS_SDK/.target

# Latest Nano X SDK (OS nanox_2.2.4 => based on API_LEVEL 5)
ENV NANOX_SDK=/opt/nanox-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOX_SDK" v5.13.1
RUN echo nanox > $NANOX_SDK/.target

# Latest Nano S+ SDK (OS nanos+_1.1.2 => based on API_LEVEL 5)
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOSP_SDK" v5.13.1
RUN echo nanos2 > $NANOSP_SDK/.target

# Latest Stax SDK (OS stax_1.5.0 => based on API_LEVEL 21)
ENV STAX_SDK=/opt/stax-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$STAX_SDK" v21.3.3
RUN echo stax > $STAX_SDK/.target

# Latest Flex SDK (OS flex_1.1.1 => based on API_LEVEL 21)
ENV FLEX_SDK=/opt/flex-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$FLEX_SDK" v21.3.3
RUN echo flex > $FLEX_SDK/.target

# Default SDK
ENV BOLOS_SDK=$NANOS_SDK

# Cleanup, remove packages that aren't needed anymore
RUN apk del python_build_deps

WORKDIR /app

# Work around the git security to be able to get informations from repositories
# even if the container is not run with root UID/GID
RUN git config --system --add safe.directory "*"

CMD ["/usr/bin/env", "bash"]
