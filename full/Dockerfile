FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest

ENV RUST_STABLE=1.91.1
ENV RUST_NIGHTLY=nightly-2025-12-05

# Add curl for Rust buildchain
RUN apt install -y --no-install-recommends curl

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

# Install ledgerctl, which is used by cargo ledger for loading or dumping an APDU app file.
RUN pip3 install --break-system-packages --no-cache-dir ledgerwallet==0.5.5

# Add cargo ledger
RUN cargo install --version 1.12.0 cargo-ledger

# Setup cargo ledger (install JSON target files and custom link script) for nightly
RUN cargo +$RUST_NIGHTLY ledger setup -t custom_target_nightly

# Make Rust directories readable and writable for all users (X adds execute only on directories)
RUN chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME