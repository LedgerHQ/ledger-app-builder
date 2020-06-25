# Ledger Application Builder

This container image contains all dependencies to compile an application for the Nano S.

## Build the container image

Several tools are available to build a container image:
```sh
# Docker
sudo docker build -t ledger-app-builder:1.6.0 .

# Podman (from https://podman.io/)
podman build -t ledger-app-builder:1.6.0 .

# Buildah (from https://buildah.io/)
buildah bud -t ledger-app-builder:1.6.0 .
```

## Compile your app

In the source folder of your Nano S application:

```console
$ sudo docker run --rm -ti -v "$(realpath .):/app" ledger-app-builder:1.6.0
root@656be163fe84:/app# make

$ podman run --rm -ti -v "$(realpath .):/app" ledger-app-builder:1.6.0
root@1f4f60f535fa:/app# make
```

The Docker image includes the [Clang Static Analyzer](https://clang-analyzer.llvm.org/), that can be invoked with:
```sh
podman run --rm -ti -v "$(realpath .):/app" ledger-app-builder:1.6.0 \
    scan-build --use-cc=clang -analyze-headers -o /app/output-scan-build make
```
