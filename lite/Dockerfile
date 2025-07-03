FROM debian:bookworm-slim

RUN apt update && apt upgrade -y

RUN apt install -y --no-install-recommends \
        clang \
        clang-format \
        clang-tools \
        cmake \
        doxygen \
        gcc-arm-none-eabi \
        git \
        jq \
        libcmocka-dev \
        lcov \
        libnewlib-arm-none-eabi \
        picolibc-arm-none-eabi \
        lld \
        llvm \
        make \
        ninja-build \
        protobuf-compiler \
        python3 \
        python3-pip

# Python package to load app onto device
RUN pip3 install --break-system-packages --no-cache-dir "ledgerblue==0.1.54" tomli-w ledgered

# Unified SDK
ARG LEDGER_SECURE_SDK=/opt/ledger-secure-sdk
RUN git clone "https://github.com/LedgerHQ/ledger-secure-sdk.git" "$LEDGER_SECURE_SDK"

# Latest Nano S SDK (OS nanos_2.1.0 => based on API_LEVEL LNS)
ENV NANOS_SDK=/opt/nanos-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOS_SDK" lns-2.1.0-v24.0
RUN echo nanos > $NANOS_SDK/.target

# Latest Nano X SDK based on API_LEVEL 22
ENV NANOX_SDK=/opt/nanox-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOX_SDK" v22.13.0
RUN echo nanox > $NANOX_SDK/.target

# Latest Nano S+ SDK based on API_LEVEL 22
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOSP_SDK" v22.13.0
RUN echo nanos2 > $NANOSP_SDK/.target

# Latest Stax SDK based on API_LEVEL 22
ENV STAX_SDK=/opt/stax-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$STAX_SDK" v22.13.0
RUN echo stax > $STAX_SDK/.target

# Latest Flex SDK based on API_LEVEL 22
ENV FLEX_SDK=/opt/flex-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$FLEX_SDK" v22.13.0
RUN echo flex > $FLEX_SDK/.target

# Default SDK
ENV BOLOS_SDK=$NANOSP_SDK

WORKDIR /app

# Work around the git security to be able to get informations from repositories
# even if the container is not run with root UID/GID
RUN git config --system --add safe.directory "*"
