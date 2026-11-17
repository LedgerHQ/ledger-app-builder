ARG BASE_IMAGE=ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest
FROM ${BASE_IMAGE}

ARG CARGO_LEDGER_VERSION=1.15.0

ENV RUSTUP_TOOLCHAIN=nightly-2025-12-05

# Release of the ledger_secure_sdk_sys crate whose target specs and link_wrap.sh
# are installed by `cargo ledger setup`. Bump it together with RUSTUP_TOOLCHAIN:
# the specs must be accepted by that nightly.
ARG LEDGER_SDK_SYS_VERSION=1.18.1

# Define rustup/cargo home directories
ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/.cargo

# Adding cargo binaries to PATH
ENV PATH=${PATH}:${CARGO_HOME}/bin

# Installing nightly channel version RUST_NIGHTLY (for Rust applications).
# add clippy and fmt to toolchain
# Adding ARMV6M target to the installed stable and nightly toolchains
# Adding rust-src component to nightly and stable channels
# Add cargo ledger
# Setup cargo ledger (install JSON target files and custom link script from the
# ledger_secure_sdk_sys crate on crates.io, checksum-verified) for nightly
# Make Rust directories readable and writable for all users (X adds execute only on directories)
RUN apt-get update && apt-get install -y --no-install-recommends python3-dev python3-pkgconfig python3-venv rsync rustup && rm -rf /var/lib/apt/lists/* && \
    rustup toolchain install $RUSTUP_TOOLCHAIN --profile minimal && \
    rustup component add clippy --toolchain "$RUSTUP_TOOLCHAIN" && \
    rustup component add rustfmt --toolchain "$RUSTUP_TOOLCHAIN" && \
    rustup target add thumbv6m-none-eabi --toolchain $RUSTUP_TOOLCHAIN && \
    rustup component add rust-src --toolchain "$RUSTUP_TOOLCHAIN" && \
    cargo install --version $CARGO_LEDGER_VERSION cargo-ledger && \
    cargo ledger setup --sys-version $LEDGER_SDK_SYS_VERSION && \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

