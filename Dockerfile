FROM alpine:3.15
ENV LANG C.UTF-8

RUN apk update
RUN apk upgrade
RUN apk add \
        clang \
        clang-extra-tools \
        clang-analyzer \
        lld \
        cmake \
        make \
        doxygen \
        git \
        python3 \
        py3-pip \
        bash \
        gcc-arm-none-eabi \
        newlib-arm-none-eabi

# Define rustup/cargo home directories
ENV RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/.cargo

RUN apk add rustup

RUN rustup-init --default-toolchain stable -y

# Adding cargo binaries to PATH
ENV PATH=${CARGO_HOME}/bin:${PATH}

# Adding ARMV6M target to the default toolchain
RUN rustup target add thumbv6m-none-eabi

# These packages contain shared libraries which will be needed at runtime
RUN apk add \
        libjpeg \
        zlib \
        eudev \
        libusb

# Python packages building dependencies, can be removed afterwards
ARG PYTHON_BUILD_DEPS=python3-dev,musl-dev,libusb-dev,eudev-dev,linux-headers,zlib-dev,jpeg-dev

RUN apk add $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

# Python package to load app onto device
RUN pip3 install ledgerblue

# Latest Nano S SDK
ENV NANOS_SDK=/opt/nanos-secure-sdk
RUN git clone --branch 2.1.0 --depth 1 https://github.com/LedgerHQ/nanos-secure-sdk.git "${NANOS_SDK}"

# Latest Nano X SDK
ENV NANOX_SDK=/opt/nanox-secure-sdk
RUN git clone --branch 2.0.2-2 --depth 1 https://github.com/LedgerHQ/nanox-secure-sdk.git "${NANOX_SDK}"

# Latest Nano S+ SDK
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
RUN git clone --branch 1.0.3 --depth 1 https://github.com/LedgerHQ/nanosplus-secure-sdk.git "${NANOSP_SDK}"

# Default SDK
ENV BOLOS_SDK=${NANOS_SDK}

# Cleanup, remove packages that aren't needed anymore
RUN apk del $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

WORKDIR /app

RUN git config --global --add safe.directory /app

CMD ["/usr/bin/env", "bash"]
