FROM debian:trixie-slim

ARG SDK_VERSION=v25.11.2
ARG CLANG_VERSION=21

RUN DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -y && apt install -y --no-install-recommends \
        cmake \
        doxygen \
        git \
        jq \
        libcmocka-dev \
        lcov \
        make \
        ninja-build \
        protobuf-compiler \
        python3 \
        python3-pip \
        wget \
        gnupg


# Install clang 21 toolchain
# TODO : LLVM has not migrated away from SHA1 signatures yet, so we need to disable the signature verification for this repository.
#        We should re-enable it as soon as LLVM migrates to a more secure signature scheme.
#        remove the [trusted=yes] option and the corresponding warning in apt update when that happens.
RUN echo "deb [trusted=yes] http://apt.llvm.org/trixie/ llvm-toolchain-trixie-$CLANG_VERSION main" >> /etc/apt/sources.list && \
    echo "deb-src [trusted=yes] http://apt.llvm.org/trixie/ llvm-toolchain-trixie-$CLANG_VERSION main" >> /etc/apt/sources.list && \
    apt update && \
    apt install -y --no-install-recommends clang-$CLANG_VERSION clang-format-$CLANG_VERSION clang-tools-$CLANG_VERSION \
                                           lld-$CLANG_VERSION llvm-$CLANG_VERSION && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/lld lld /usr/bin/lld-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-$CLANG_VERSION 100 && \
    rm -rf /var/lib/apt/lists/*

# Python package to load app onto device
RUN pip3 install --break-system-packages --no-cache-dir "ledgerblue==0.1.54" tomli-w ledgered semver

# Unified SDK
ARG LEDGER_SECURE_SDK=/opt/ledger-secure-sdk
RUN git clone "https://github.com/LedgerHQ/ledger-secure-sdk.git" "$LEDGER_SECURE_SDK"

# Latest Nano S SDK (OS nanos_2.1.0 => based on API_LEVEL LNS)
ENV NANOS_SDK=/opt/nanos-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOS_SDK" lns-2.1.0-v24.0
RUN echo nanos > $NANOS_SDK/.target

# Latest Nano X SDK based on API_LEVEL 25
ENV NANOX_SDK=/opt/nanox-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOX_SDK" $SDK_VERSION
RUN echo nanox > $NANOX_SDK/.target

# Latest Nano S+ SDK based on API_LEVEL 25
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOSP_SDK" $SDK_VERSION
RUN echo nanos2 > $NANOSP_SDK/.target

# Latest Stax SDK based on API_LEVEL 25
ENV STAX_SDK=/opt/stax-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$STAX_SDK" $SDK_VERSION
RUN echo stax > $STAX_SDK/.target

# Latest Flex SDK based on API_LEVEL 25
ENV FLEX_SDK=/opt/flex-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$FLEX_SDK" $SDK_VERSION
RUN echo flex > $FLEX_SDK/.target

# Latest Apex P SDK based on API_LEVEL 25
ENV APEX_P_SDK=/opt/apex-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$APEX_P_SDK" $SDK_VERSION
RUN echo apex_p > $APEX_P_SDK/.target

# Default SDK
ENV BOLOS_SDK=$NANOSP_SDK

WORKDIR /app

# Work around the git security to be able to get informations from repositories
# even if the container is not run with root UID/GID
RUN git config --system --add safe.directory "*"
