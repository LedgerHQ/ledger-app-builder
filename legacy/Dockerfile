FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest AS LITE_BUILDER

FROM ubuntu:22.04
ENV LANG C.UTF-8

ARG DEBIAN_FRONTEND=noninteractive

ARG LLVM_VERSION=12

ARG RUST_STABLE_VERSION=1.75.0
ARG RUST_NIGHTLY_VERSION=nightly-2023-11-10

ENV RUST_STABLE=$RUST_STABLE_VERSION
ENV RUST_NIGHTLY=$RUST_NIGHTLY_VERSION


RUN apt-get update && apt-get upgrade -qy
RUN apt-get install -qy \
        clang-$LLVM_VERSION \
        cmake \
        curl \
        wget \
        gpg-agent \
        software-properties-common \
        git \
        lld-$LLVM_VERSION \
        make \
        protobuf-compiler \
        python-is-python3 \
        python3 \
        python3-pip && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean

# Create generic clang & lld symbolic links to their installed version
RUN cd /usr/bin && \
    find . -name "*-"$LLVM_VERSION | sed "s/^\(.*\)\(-"$LLVM_VERSION"\)$/ln -s \1\2 \1/" | sh

# ARM Embedded Toolchain
# Integrity is checked using the MD5 checksum provided by ARM at https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
ENV TOOLCHAIN_VERSION 10.3-2021.10
RUN case $(uname -m) in \
        x86_64 | amd64) \
            ARCH=x86_64 \
            MD5=2383e4eb4ea23f248d33adc70dc3227e;; \
        aarch64 | arm64) \
            ARCH=aarch64; \
            MD5=3fe3d8bb693bd0a6e4615b6569443d0d;; \
        *) echo "Unkown architecture" && exit 1;; \
    esac && \
    curl -sSfL -o arm-toolchain.tar.bz2 "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/${TOOLCHAIN_VERSION}/gcc-arm-none-eabi-${TOOLCHAIN_VERSION}-${ARCH}-linux.tar.bz2" && \
    echo ${MD5} arm-toolchain.tar.bz2 > /tmp/arm-toolchain.md5 && \
	md5sum --check /tmp/arm-toolchain.md5 && rm /tmp/arm-toolchain.md5 && \
    tar xf arm-toolchain.tar.bz2 -C /opt && \
    rm arm-toolchain.tar.bz2

# Adding GCC to PATH and defining rustup/cargo home directories
ENV PATH=/opt/gcc-arm-none-eabi-${TOOLCHAIN_VERSION}/bin:$PATH \
	RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/.cargo

# Adding cargo binaries to PATH
ENV PATH=${CARGO_HOME}/bin:${PATH}

# Installing rustup to manage rust toolchains and setting the default toolchain to the RUST_STABLE_VERSION stable channel.
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain $RUST_STABLE_VERSION -y

# Installing nightly channel version RUST_NIGHTLY_VERSION
RUN rustup install $RUST_NIGHTLY_VERSION

# Adding ARMV6M target to the installed stable toolchain
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_STABLE_VERSION
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_NIGHTLY_VERSION

# Adding rust-src component to nightly and stable channels
RUN rustup component add rust-src --toolchain $RUST_NIGHTLY_VERSION
RUN rustup component add rust-src --toolchain $RUST_STABLE_VERSION

# Add ledgerwallet python package used by cargo ledger to generate the app APDU file
RUN pip3 install ledgerwallet==0.4.0

# Add cargo ledger
RUN cargo +$RUST_STABLE_VERSION install --version 1.3.0 cargo-ledger

# Setup cargo ledger (install JSON target files and custom link script)
RUN cargo +$RUST_NIGHTLY_VERSION ledger setup

# Adding LLVM-15 APT repository and installing it
RUN wget --no-check-certificate -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main"
RUN apt-get update \
    && apt-get install -y --no-install-recommends llvm-15

# Python package to load app onto device
RUN pip3 install ledgerblue

ENV NANOS_SDK=/opt/nanos-secure-sdk
ENV NANOX_SDK=/opt/nanox-secure-sdk
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
ENV STAX_SDK=/opt/stax-secure-sdk

# Copy the SDKs from the lite container
COPY --from=LITE_BUILDER /opt/ /opt/

# Default SDK
ENV BOLOS_SDK=${NANOS_SDK}

WORKDIR /app

# Work around the git security to be able to get informations from repositories
# even if the container is not run with root UID/GID
RUN git config --system --add safe.directory "*"

CMD ["/usr/bin/env", "bash"]
