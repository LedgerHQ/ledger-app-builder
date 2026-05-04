FROM debian:trixie-slim

ARG SDK_VERSION=4211d91290681e9eacabbfc6b7036b493602c14f
ARG CLANG_VERSION=21

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        cmake \
        doxygen \
        git \
        jq \
        lcov \
        libbsd-dev \
        libcmocka-dev \
        lcov \
        make \
        ninja-build \
        picolibc-arm-none-eabi \
        pkg-config \
        protobuf-compiler \
        python3 \
        python3-pip \
        wget \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi \
        picolibc-arm-none-eabi \
        gnupg

# Install clang 21 toolchain
RUN wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] https://apt.llvm.org/trixie/ llvm-toolchain-trixie-$CLANG_VERSION main" > /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] https://apt.llvm.org/trixie/ llvm-toolchain-trixie-$CLANG_VERSION main" >> /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang-$CLANG_VERSION clang-format-$CLANG_VERSION clang-tools-$CLANG_VERSION \
                                           lld-$CLANG_VERSION llvm-$CLANG_VERSION && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/lld lld /usr/bin/lld-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/llvm-ranlib llvm-ranlib /usr/bin/llvm-ranlib-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/llvm-objcopy-$CLANG_VERSION 100 && \
    update-alternatives --install /usr/bin/llvm-nm llvm-nm /usr/bin/llvm-nm-$CLANG_VERSION 100 && \
    rm -rf /var/lib/apt/lists/*

# Python package to load app onto device
RUN pip3 install --break-system-packages --no-cache-dir "ledgerblue==0.1.55" tomli-w ledgered semver

# Unified SDK
ARG LEDGER_SECURE_SDK=/opt/ledger-secure-sdk
RUN git clone -b $SDK_VERSION --no-single-branch "https://github.com/LedgerHQ/ledger-secure-sdk.git" "$LEDGER_SECURE_SDK"

# Latest Nano S SDK (OS nanos_2.1.0 => based on API_LEVEL LNS)
ENV NANOS_SDK=/opt/nanos-secure-sdk
ENV NANOX_SDK=/opt/nanox-secure-sdk
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
ENV STAX_SDK=/opt/stax-secure-sdk
ENV FLEX_SDK=/opt/flex-secure-sdk
ENV APEX_P_SDK=/opt/apex-secure-sdk

# Default SDK
ENV BOLOS_SDK=$NANOSP_SDK

RUN git -C "$LEDGER_SECURE_SDK" worktree add -d "$NANOS_SDK" lns-2.1.0-v24.0 && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$NANOX_SDK"  $SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$NANOSP_SDK" $SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$STAX_SDK"   $SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$FLEX_SDK"   $SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$APEX_P_SDK" $SDK_VERSION && \
    echo nanos  > $NANOS_SDK/.target && \
    echo nanox  > $NANOX_SDK/.target && \
    echo nanos2 > $NANOSP_SDK/.target && \
    echo stax   > $STAX_SDK/.target && \
    echo flex   > $FLEX_SDK/.target && \
    echo apex_p > $APEX_P_SDK/.target

WORKDIR /app

# Work around the git security to be able to get informations from repositories
# even if the container is not run with root UID/GID
RUN git config --system --add safe.directory "*"
