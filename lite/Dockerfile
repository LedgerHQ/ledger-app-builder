FROM debian:trixie-slim@sha256:b6e2a152f22a40ff69d92cb397223c906017e1391a73c952b588e51af8883bf8

ARG NANOSP_SDK_VERSION=v26.1.7
ARG NANOX_SDK_VERSION=v26.1.7
ARG STAX_SDK_VERSION=v26.1.7
ARG FLEX_SDK_VERSION=v26.1.7
ARG APEX_P_SDK_VERSION=v26.1.7

ARG CLANG_MAJOR=21
ARG CLANG_NIGHTLY=1:21.1.8~++20251221033036+2078da43e25a-1~exp1~20251221153213.50

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        autoconf=2.72-3.1 \
        automake=1:1.17-4 \
        build-essential=12.12 \
        cmake=3.31.6-2 \
        doxygen=1.9.8+ds-2.1 \
        gcc-arm-none-eabi=15:14.2.rel1-1 \
        git=1:2.47.3-0+deb13u1 \
        gnupg=2.4.7-21+deb13u1 \
        jq=1.7.1-6+deb13u2 \
        lcov=2.3.1-1 \
        libbsd-dev=0.12.2-2 \
        libcmocka-dev=1.1.7-3+b1 \
        libnewlib-arm-none-eabi=4.5.0.20241231-1 \
        libtool=2.5.4-4 \
        make=4.4.1-2 \
        ninja-build=1.12.1-1 \
        picolibc-arm-none-eabi=1.8.10-2 \
        pkg-config=1.8.1-4 \
        protobuf-compiler=3.21.12-11 \
        python-is-python3=3.13.3-1 \
        python3=3.13.5-1 \
        python3-pip=25.1.1+dfsg-1 \
        wget=1.25.0-2

# Install clang 21 toolchain
RUN wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] https://apt.llvm.org/trixie/ llvm-toolchain-trixie-$CLANG_MAJOR main" > /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] https://apt.llvm.org/trixie/ llvm-toolchain-trixie-$CLANG_MAJOR main" >> /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang-$CLANG_MAJOR=${CLANG_NIGHTLY} clang-format-$CLANG_MAJOR=${CLANG_NIGHTLY} clang-tools-$CLANG_MAJOR=${CLANG_NIGHTLY} \
                                           lld-$CLANG_MAJOR=${CLANG_NIGHTLY} llvm-$CLANG_MAJOR=${CLANG_NIGHTLY} && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$CLANG_MAJOR 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$CLANG_MAJOR 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-$CLANG_MAJOR 100 && \
    update-alternatives --install /usr/bin/lld lld /usr/bin/lld-$CLANG_MAJOR 100 && \
    update-alternatives --install /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-$CLANG_MAJOR 100 && \
    update-alternatives --install /usr/bin/llvm-ranlib llvm-ranlib /usr/bin/llvm-ranlib-$CLANG_MAJOR 100 && \
    update-alternatives --install /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/llvm-objcopy-$CLANG_MAJOR 100 && \
    update-alternatives --install /usr/bin/llvm-nm llvm-nm /usr/bin/llvm-nm-$CLANG_MAJOR 100 && \
    rm -rf /var/lib/apt/lists/*

# Python package to load app onto device
RUN pip3 install --break-system-packages --no-cache-dir "ledgerblue==0.1.55" tomli-w ledgered semver

# Unified SDK
ARG LEDGER_SECURE_SDK=/opt/ledger-secure-sdk
RUN git clone "https://github.com/LedgerHQ/ledger-secure-sdk.git" "$LEDGER_SECURE_SDK"

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
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$NANOX_SDK"  $NANOX_SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$NANOSP_SDK" $NANOSP_SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$STAX_SDK"   $STAX_SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$FLEX_SDK"   $FLEX_SDK_VERSION && \
    git -C "$LEDGER_SECURE_SDK" worktree add -d "$APEX_P_SDK" $APEX_P_SDK_VERSION && \
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
