FROM alpine:3.15
ENV LANG C.UTF-8

RUN apk update
RUN apk upgrade
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
        lld \
        make \
        musl-dev \
        newlib-arm-none-eabi \
        protoc \
        py3-pip \
        python3

# lcov is only present in the testing repository of the edge branch
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing lcov

# So that it still supports things incorrectly pointing to python
RUN ln -s python3 $(dirname $(which python3))/python

# These packages contain shared libraries which will be needed at runtime
RUN apk add \
        eudev \
        libjpeg \
        libusb \
        zlib

# Python packages building dependencies, can be removed afterwards
ARG PYTHON_BUILD_DEPS=eudev-dev,jpeg-dev,libusb-dev,linux-headers,python3-dev,zlib-dev

RUN apk add $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

# Python package to load app onto device
RUN pip3 install ledgerblue tomli-w

ARG GIT_SERVER=https://github.com/LedgerHQ

# Latest Nano S SDK
# Will switch to the unified SDK for next OS release.
ENV NANOS_SDK=/opt/nanos-secure-sdk
RUN git clone --branch v2.1.0-4 --depth 1 "$GIT_SERVER/nanos-secure-sdk.git" "$NANOS_SDK"

# Unified SDK
ENV LEDGER_SECURE_SDK=/opt/ledger-secure-sdk
RUN git clone "$GIT_SERVER/ledger-secure-sdk.git" "$LEDGER_SECURE_SDK"

# Latest Nano X SDK (OS nanox_2.1.0 => based on API_LEVEL 1 => clone on SDK tag v1.4.0)
ENV NANOX_SDK=/opt/nanox-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOX_SDK" v1.4.0
RUN echo nanox > $NANOX_SDK/.target

# Latest Nano S+ SDK (OS nanos+_1.1.0 => based on API_LEVEL 1 => clone on SDK tag v1.4.0)
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOSP_SDK" v1.4.0
RUN echo nanos2 > $NANOSP_SDK/.target

# Latest Stax SDK (OS stax_1.0.0 => based on API_LEVEL 8 => clone on SDK tag v8.1.0)
ENV STAX_SDK=/opt/stax-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$STAX_SDK" v8.1.0
RUN echo stax > $STAX_SDK/.target

# Default SDK
ENV BOLOS_SDK=$NANOS_SDK

# Cleanup, remove packages that aren't needed anymore
RUN apk del $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

WORKDIR /app

# Work around the git security to be able to get informations from repositories
# even if the container is not run with root UID/GID
RUN git config --system --add safe.directory "*"

CMD ["/usr/bin/env", "bash"]
