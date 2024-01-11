FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest

ARG RUST_STABLE_VERSION=1.75.0
ARG RUST_NIGHTLY_VERSION=nightly-2023-11-10

# Add curl for Rust buildchain
RUN apk add --update-cache --upgrade curl

# Define rustup/cargo home directories
ENV RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/.cargo

RUN apk add rustup

# Adding cargo binaries to PATH
ENV PATH=${CARGO_HOME}/bin:${PATH}

# Installing rustup and setting the default toolchain to the RUST_NIGHTLY_VERSION nightly channel.
RUN rustup-init --default-toolchain $RUST_NIGHTLY_VERSION -y

# Installing stable channel version RUST_STABLE_VERSION as well (for cargo-ledger installation).
RUN rustup install $RUST_STABLE_VERSION

# Adding ARMV6M target to the installed nightly toolchain
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_NIGHTLY_VERSION

# Adding rust-src component to nightly channel
RUN rustup component add rust-src --toolchain $RUST_NIGHTLY_VERSION

# Python packages building dependencies, can be removed afterwards
RUN apk add -t python_build_deps python3-dev \
                                 libffi-dev

# Install ledgerctl, which is used by cargo ledger for loading or dumping an APDU app file.
RUN pip3 install ledgerwallet==0.4.0

# Cleanup, remove packages that aren't needed anymore
RUN apk del python_build_deps

# Add cargo ledger (needs a version of Rust >= 1.70)
RUN cargo +$RUST_STABLE_VERSION install --version 1.2.3 cargo-ledger

# Setup cargo ledger (install JSON target files)
RUN cargo ledger setup

# Add a global Cargo config file (includes mandatory unstable features used to build our apps) 
ADD ./full/cargo_global_config.toml $CARGO_HOME/config.toml
