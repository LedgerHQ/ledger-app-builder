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
        doxygen \
        gcc-arm-none-eabi \
        git \
        lld \
        make \
        newlib-arm-none-eabi \
        protoc \
        py3-pip \
        python3

# lcov is only present in the testing repository of the edge branch
RUN apk add lcov --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

# So that it still supports things incorrectly pointing to python
RUN ln -s python3 $(dirname $(which python3))/python

# These packages contain shared libraries which will be needed at runtime
RUN apk add \
        eudev \
        libjpeg \
        libusb \
        zlib

# Python packages building dependencies, can be removed afterwards
ARG PYTHON_BUILD_DEPS=eudev-dev,jpeg-dev,libusb-dev,linux-headers,musl-dev,python3-dev,zlib-dev

RUN apk add $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

# Python package to load app onto device
RUN pip3 install ledgerblue

ARG GIT_SERVER=https://github.com/LedgerHQ

# Latest Nano S SDK
ENV NANOS_SDK=/opt/nanos-secure-sdk
RUN git clone --branch 2.1.0 --depth 1 "$GIT_SERVER/nanos-secure-sdk.git" "$NANOS_SDK"

# Latest Nano X SDK
ENV NANOX_SDK=/opt/nanox-secure-sdk
RUN git clone --branch 2.0.2-2 --depth 1 "$GIT_SERVER/nanox-secure-sdk.git" "$NANOX_SDK"

# Latest Nano S+ SDK
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
RUN git clone --branch 1.0.3 --depth 1 "$GIT_SERVER/nanosplus-secure-sdk.git" "$NANOSP_SDK"

# Default SDK
ENV BOLOS_SDK=$NANOS_SDK

# Cleanup, remove packages that aren't needed anymore
RUN apk del $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

WORKDIR /app

RUN git config --global --add safe.directory /app

CMD ["/usr/bin/env", "bash"]
