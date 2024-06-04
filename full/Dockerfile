FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest

ARG RUST_STABLE_VERSION=1.75.0
ARG RUST_NIGHTLY_VERSION=nightly-2023-11-10

ENV RUST_STABLE=$RUST_STABLE_VERSION
ENV RUST_NIGHTLY=$RUST_NIGHTLY_VERSION

# Add curl for Rust buildchain
RUN apk add --update-cache --upgrade curl

# Define rustup/cargo home directories
ENV RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/.cargo

RUN apk add rustup

# Adding cargo binaries to PATH
ENV PATH=${CARGO_HOME}/bin:${PATH}

# Installing rustup and setting the default toolchain to the RUST_STABLE_VERSION channel.
RUN rustup-init --default-toolchain $RUST_STABLE_VERSION -y

# Installing nightly channel version RUST_NIGHTLY_VERSION (for Rust applications).
RUN rustup install $RUST_NIGHTLY_VERSION

# Adding ARMV6M target to the installed stable and nightly toolchains
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_STABLE_VERSION
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_NIGHTLY_VERSION

# Adding rust-src component to nightly and stable channels
RUN rustup component add rust-src --toolchain $RUST_NIGHTLY_VERSION
RUN rustup component add rust-src --toolchain $RUST_STABLE_VERSION

# Python packages building dependencies, can be removed afterwards
RUN apk add -t python_build_deps python3-dev \
                                 libffi-dev

# Install ledgerctl, which is used by cargo ledger for loading or dumping an APDU app file.
RUN pip3 install ledgerwallet==0.5.0

# Cleanup, remove packages that aren't needed anymore
RUN apk del python_build_deps

# Add cargo ledger
RUN cargo +$RUST_STABLE_VERSION install --version 1.4.1 cargo-ledger

# Setup cargo ledger (install JSON target files and custom link script) for nightly
RUN cargo +$RUST_NIGHTLY_VERSION ledger setup

# Add a global Cargo config file (includes mandatory unstable features used to build our apps) 
ADD ./full/cargo_global_config.toml $CARGO_HOME/config.toml
