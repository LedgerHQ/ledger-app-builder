FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest

ARG CARGO_LEDGER_VERSION=1.14.0

ENV RUST_NIGHTLY=nightly-2025-12-05

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
# Setup cargo ledger (install JSON target files and custom link script) for nightly
# Make Rust directories readable and writable for all users (X adds execute only on directories)
RUN apt-get update && apt-get install -y --no-install-recommends python3-dev python3-pkgconfig python3-venv rsync rustup && rm -rf /var/lib/apt/lists/* && \
    rustup toolchain install $RUST_NIGHTLY --profile minimal && \
    rustup component add clippy --toolchain "$RUST_NIGHTLY" && \
    rustup component add rustfmt --toolchain "$RUST_NIGHTLY" && \
    rustup target add thumbv6m-none-eabi --toolchain $RUST_NIGHTLY && \
    rustup component add rust-src --toolchain "$RUST_NIGHTLY" && \
    cargo install --version $CARGO_LEDGER_VERSION cargo-ledger && \
    cargo +$RUST_NIGHTLY ledger setup -t custom_target_nightly && \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

