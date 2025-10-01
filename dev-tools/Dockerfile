FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest

RUN apt install -y --no-install-recommends \
        imagemagick \
        libgl1 \
        libpython3-dev \
        pkg-config \
        python3-pyqt6 \
        python3-venv \
        qemu-user-static

RUN apt install -y --no-install-recommends \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-render-util0 \
        libxcb-shape0 \
        libxcb-xinerama0 \
        libxcb-xkb1 \
        libxkbcommon-x11-0

# Install test tools (Ragger framework, Speculos emulator, Ledgerblue...)
RUN pip3 install --break-system-packages --no-cache-dir "speculos==0.25.7"

# Add the enforcer script
ADD ./dev-tools/enforcer.sh /opt/enforcer.sh
