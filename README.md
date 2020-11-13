# Ledger Application Builder

This container image contains all dependencies to compile an application for the Nano S.

## Build the container image

Several tools are available to build a container image:

```bash
$ # Docker
$ sudo docker build -t ledger-app-builder:1.6.1-2 .
$ # Podman (from https://podman.io/)
$ podman build -t ledger-app-builder:1.6.1-2 .
$ # Buildah (from https://buildah.io/)
$ buildah bud -t ledger-app-builder:1.6.1-2 .
```

## Compile your app in the container

In the source folder of your Nano S application:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" ledger-app-builder:1.6.1-2
root@656be163fe84:/app# make
```

The Docker image includes the [Clang Static Analyzer](https://clang-analyzer.llvm.org/), which can be invoked with:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" ledger-app-builder:1.6.1-2 \
    scan-build --use-cc=clang -analyze-headers -o /app/output-scan-build make
```
