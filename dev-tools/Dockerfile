FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest

RUN apk add libusb \
            py3-qt5 \
            qemu-arm \
            tesseract-ocr

ARG QEMU_BIN=qemu-arm

# -static version is not available in Alpine repositories
RUN ln -s "$QEMU_BIN" $(dirname $(which "$QEMU_BIN"))/$QEMU_BIN-static

# Python packages building dependencies, can be removed afterwards
ARG PYTHON_BUILD_DEPS=libffi-dev,musl-dev,python3-dev

# Install the building dependencies.
RUN apk add $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

# Install test tools (Ragger framework, Speculos emulator, Ledgerblue...)
RUN pip3 install --extra-index-url https://test.pypi.org/simple/ ragger[tests,all_backends]

# Cleanup, remove packages that aren't needed anymore
RUN apk del $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')