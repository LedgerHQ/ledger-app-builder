# Ledger Application Builder

This container image contains all dependencies to compile an application for the Nano S.

## Build the container image

### Standard Build

Container can be build using standard tools:

```bash
# Docker
sudo docker build -t ledger-app-builder:2.0.0-1 .
# Podman (from https://podman.io/)
podman build -t ledger-app-builder:2.0.0-1 .
# Buildah (from https://buildah.io/)
buildah bud -t ledger-app-builder:2.0.0-1 .
```

### App Scanner

Image can embed the [Coverity Scan](https://scan.coverity.com/) build tool. It is an excellent static analysis tool, and it can be very useful to find bugs in Nano apps.

The build tool must be downloaded before building the image. Archive can be downloaded from <https://scan.coverity.com/download>. Download is available to everyone, but it requires to create an account. After having registered, download Coverity Build Tool 2020.09 for Linux64 and place the downloaded archive in the `coverity` directory.

Then, build container with:

```bash
# Docker
sudo docker build -t ledger-app-scanner:2.0.0-1 .
# Podman (from https://podman.io/)
podman build -t ledger-app-scanner:2.0.0-1 .
# Buildah (from https://buildah.io/)
buildah bud -t ledger-app-scanner:2.0.0-1 .
```

## Compile your app in the container

In the source folder of your Nano S application:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" ledger-app-builder:2.0.0-1
root@656be163fe84:/app# make
```

The Docker image includes the [Clang Static Analyzer](https://clang-analyzer.llvm.org/), which can be invoked with:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" ledger-app-builder:2.0.0-1
root@656be163fe84:/app# make scan-build
```
