FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest

RUN apk add libusb \
            ttf-dejavu \
            fontconfig \
            py3-qt5 \
            qemu-arm \
            tesseract-ocr \
            mesa-dri-gallium

ARG QEMU_BIN=qemu-arm

# -static version is not available in Alpine repositories
RUN ln -s "$QEMU_BIN" $(dirname $(which "$QEMU_BIN"))/$QEMU_BIN-static

# Python packages building dependencies
ARG PYTHON_BUILD_DEPS=libffi-dev,python3-dev,py3-virtualenv

# Install the building dependencies.
RUN apk add $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

# Install packahes to allow Guideline Enforcer to run
RUN apk add imagemagick grep

# Install test tools (Ragger framework, Speculos emulator, Ledgerblue...)
RUN pip3 install --no-cache-dir "ragger[tests,all_backends]==1.29.0" "speculos==0.16.0"

# Add the enforcer script
ADD ./dev-tools/enforcer.sh /opt/enforcer.sh
