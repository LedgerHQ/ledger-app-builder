FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest

# Switch to root to install packages
USER root

RUN apt install -y --no-install-recommends \
        imagemagick \
        libgl1 \
        libpython3-dev \
        pkg-config \
        python3-pyqt6 \
        python3-venv \
        qemu-user-static \
        libvncserver-dev

RUN apt install -y --no-install-recommends \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-render-util0 \
        libxcb-shape0 \
        libxcb-xinerama0 \
        libxcb-xkb1 \
        libxkbcommon-x11-0

# Install build dependencies for speculos
RUN apt install -y --no-install-recommends \
        gcc-arm-linux-gnueabihf \
        libc6-dev-armhf-cross

# Build speculos from source
RUN pip3 install --break-system-packages --no-cache-dir --no-binary speculos "speculos==0.25.13"

# Add the enforcer script
ADD ./dev-tools/enforcer.sh /opt/enforcer.sh

# Create a system-wide python venv writeable for all users
ENV VENV_PATH=/opt/venv
RUN python3 -m venv $VENV_PATH --system-site-packages && \
    chmod -R a+rwX $VENV_PATH

# Set pip cache directory to a writable location
ENV PIP_CACHE_DIR=/opt/venv/pip-cache
RUN mkdir -p $PIP_CACHE_DIR && chmod -R a+rwX $PIP_CACHE_DIR

# Automatically activate venv for all users
RUN echo 'source /opt/venv/bin/activate' >> /etc/bash.bashrc

# Switch back to base_user (inherited from lite)
USER base_user
WORKDIR /home/base_user
