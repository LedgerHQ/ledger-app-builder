# FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest
FROM ledger-app-builder:lite

ARG RUST_STABLE_VERSION=1.72.0
ARG RUST_NIGHTLY_VERSION=nightly-2022-12-02

# Add curl for Rust buildchain
RUN apk add curl

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

# Add cargo ledger (needs a version of Rust >= 1.70)
RUN cargo +$RUST_STABLE_VERSION install --locked --git=https://github.com/LedgerHQ/cargo-ledger.git --rev 1.1.0 cargo-ledger
