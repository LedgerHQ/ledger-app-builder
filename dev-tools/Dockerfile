FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest

ARG SPECULOS_VERSION

ENV VENV_PATH=/opt/venv
ENV PIP_CACHE_DIR=/opt/venv/pip-cache

# Add the enforcer script
COPY ./dev-tools/enforcer.sh /opt/enforcer.sh

# Create a system-wide python venv writeable for all users
# Set pip cache directory to a writable location
# Automatically activate venv for all users
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc-arm-linux-gnueabihf \
        imagemagick \
        libc6-dev-armhf-cross \
        libgl1 \
        libpython3-dev \
        libvncserver-dev \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-render-util0 \
        libxcb-shape0 \
        libxcb-xinerama0 \
        libxcb-xkb1 \
        libxkbcommon-x11-0 \
        python3-pyqt6 \
        qemu-user-static && \
     pip3 install --break-system-packages --no-cache-dir --no-binary speculos "speculos==${SPECULOS_VERSION}" && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/* && \
     python3 -m venv $VENV_PATH --system-site-packages && \
     chmod -R a+rwX $VENV_PATH && \
     mkdir -p $PIP_CACHE_DIR && chmod -R a+rwX $PIP_CACHE_DIR && \
     echo 'source /opt/venv/bin/activate' >> /etc/bash.bashrc

