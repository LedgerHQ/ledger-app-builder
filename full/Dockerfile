#FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest
FROM test-lite:latest

ENV RUST_STABLE=1.83.0
ENV RUST_NIGHTLY=nightly-2024-12-01

# Define rustup/cargo home directories for system-wide installation
ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo

# Adding cargo binaries to PATH
ENV PATH=${CARGO_HOME}/bin:${PATH}

# Installing rustup and setting the default toolchain to the RUST_STABLE channel.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain $RUST_STABLE -y --no-modify-path

# Installing nightly channel version RUST_NIGHTLY (for Rust applications).
RUN rustup install $RUST_NIGHTLY

# Adding ARMV6M target to the installed stable and nightly toolchains
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_STABLE
RUN rustup target add thumbv6m-none-eabi --toolchain $RUST_NIGHTLY

# Adding rust-src component to nightly and stable channels
RUN rustup component add rust-src --toolchain $RUST_NIGHTLY
RUN rustup component add rust-src --toolchain $RUST_STABLE

# Add cargo ledger
RUN cargo install --version 1.9.0 cargo-ledger

# Setup cargo ledger (install JSON target files and custom link script) for nightly
RUN cargo ledger setup

# Make Rust directories readable and writable for all users (X adds execute only on directories)
RUN chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME