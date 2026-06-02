FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest

ARG SPECULOS_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc-arm-linux-gnueabihf=4:14.2.0-1 \
        imagemagick=8:7.1.1.43+dfsg1-1+deb13u9 \
        libc6-dev-armhf-cross=2.41-11cross1 \
        libgl1=1.7.0-1+b2 \
        libpython3-dev=3.13.5-1 \
        libvncserver-dev=0.9.15+dfsg-1+deb13u1 \
        libxcb-icccm4=0.4.2-1 \
        libxcb-image0=0.4.0-2+b2 \
        libxcb-keysyms1=0.4.1-1 \
        libxcb-render-util0=0.3.10-1 \
        libxcb-shape0=1.17.0-2+b1 \
        libxcb-xinerama0=1.17.0-2+b1 \
        libxcb-xkb1=1.17.0-2+b1 \
        libxkbcommon-x11-0=1.7.0-2 \
        python3-pyqt6=6.9.0-2 \
        qemu-user-static=1:10.0.8+ds-0+deb13u1+b2 && \
     pip3 install --break-system-packages --no-cache-dir --no-binary speculos "speculos==${SPECULOS_VERSION}" && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/*

# Add the enforcer script
COPY ./dev-tools/enforcer.sh /opt/enforcer.sh

# Create a system-wide python venv writeable for all users
ENV VENV_PATH=/opt/venv
RUN python3 -m venv $VENV_PATH --system-site-packages && \
    chmod -R a+rwX $VENV_PATH

# Set pip cache directory to a writable location
ENV PIP_CACHE_DIR=/opt/venv/pip-cache
RUN mkdir -p $PIP_CACHE_DIR && chmod -R a+rwX $PIP_CACHE_DIR

# Automatically activate venv for all users
RUN echo 'source /opt/venv/bin/activate' >> /etc/bash.bashrc

