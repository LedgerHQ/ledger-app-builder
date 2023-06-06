FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest

# Define rustup/cargo home directories
ENV RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/.cargo

RUN apk add rustup

RUN rustup-init --default-toolchain stable -y

# Adding cargo binaries to PATH
ENV PATH=${CARGO_HOME}/bin:${PATH}

# Adding ARMV6M target to the default toolchain
RUN rustup target add thumbv6m-none-eabi

# Adding rust-src component
RUN rustup component add rust-src
