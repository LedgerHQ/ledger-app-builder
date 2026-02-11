# FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest
FROM ledger-app-builder-lite:latest
#FROM trixie-lite-clang-21:latest

ENV RUST_STABLE=1.92.0
ENV RUST_NIGHTLY=nightly-2025-12-05

# Add curl for Rust buildchain
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl python3-dev python3-pkgconfig python3-venv rsync && \
    rm -rf /var/lib/apt/lists/*

# Define rustup/cargo home directories
ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/.cargo

# Adding cargo binaries to PATH
ENV PATH=${PATH}:${CARGO_HOME}/bin

# Installing rustup and setting the default toolchain to the RUST_STABLE channel.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain $RUST_STABLE -y

# Installing nightly channel version RUST_NIGHTLY (for Rust applications).
RUN rustup toolchain install $RUST_NIGHTLY

# Adding ARMV6M target to the installed stable and nightly toolchains
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_STABLE
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_NIGHTLY

# Adding rust-src component to nightly and stable channels
RUN rustup component add rust-src --toolchain $RUST_NIGHTLY
RUN rustup component add rust-src --toolchain $RUST_STABLE

# Add cargo ledger
RUN cargo install --version 1.13.0 cargo-ledger

# Setup cargo ledger (install JSON target files and custom link script) for nightly
RUN cargo +$RUST_NIGHTLY ledger setup -t custom_target_nightly

# Make Rust directories readable and writable for all users (X adds execute only on directories)
RUN chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

