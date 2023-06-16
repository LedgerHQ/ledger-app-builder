FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest

# Define rustup/cargo home directories
ENV RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/.cargo

RUN apk add rustup

# Adding cargo binaries to PATH
ENV PATH=${CARGO_HOME}/bin:${PATH}

# Installing rustup and setting the default toolchain to the 1.70.0 stable channel.
RUN rustup-init --default-toolchain 1.67.0 -y

# Installing nightly channel version 1.67.0 as well.
RUN rustup install nightly-2022-12-02

# Adding ARMV6M target to the installed toolchains
RUN rustup target add thumbv6m-none-eabi --toolchain 1.67.0
RUN rustup target add thumbv6m-none-eabi --toolchain nightly-2022-12-02

# Adding rust-src component to nightly channel
RUN rustup component add rust-src --toolchain nightly-2022-12-02
