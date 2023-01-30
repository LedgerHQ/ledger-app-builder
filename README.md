# Ledger Application Builder

These container images contain all dependencies to compile an application for Nano S/S+/X.

The three images are stored in the following directories:

- `lite` is based on `Alpine` and is the lightest of the app-builder docker images. It contains enough to compile `C`-only applications. It does **not** contain the `glibc`, so tools/analyzers using it won't work.
- `full` is the default image. It derives from `lite` and contains tools allowing `Rust` compilation.
- `legacy` contains all needed tools to compile `C` and `Rust` applications. This image is quite heavy, but based on Ubuntu 22.04, so it is a good pick for tools using the `glibc`, such as `SonarQube` or `CodeQL`.

## Using Ledger images

The images corresponding to the previous Dockerfiles are built and pushed on [ghcr.io](ghcr.io) every time the SDK is updated.
They can be pulled via these commands:

```bash
# pull the lite image, built from `lite/Dockerfile`
$ sudo docker pull ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-lite:latest
# pull the default, full image, built from `full/Dockerfile`
$ sudo docker pull ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest
# pull the legacy image, built from `legacy/Dockerfile`
$ sudo docker pull ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder-legacy:latest
```

## Compile your app in the container

In the source folder of your application, for Nano S:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" --user $(id -u $USER):$(id -g $USER) ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest
root@656be163fe84:/app# BOLOS_SDK=$NANOS_SDK make
```

The Docker image includes the [Clang Static Analyzer](https://clang-analyzer.llvm.org/), which can be invoked with:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" --user $(id -u $USER):$(id -g $USER) ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest
root@656be163fe84:/app# BOLOS_SDK=$NANOS_SDK make scan-build
```

For Nano X, specify the `BOLOS_SDK` environment variable before building your app with the pre-defined `$NANOX_SDK` variable:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" --user $(id -u $USER):$(id -g $USER) ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest
root@656be163fe84:/app# BOLOS_SDK=$NANOX_SDK make
```

For Nano S+, specify the `BOLOS_SDK` environment variable before building your app with the pre-defined `$NANOSP_SDK` variable:

```bash
$ # docker can be replaced with podman or buildah without sudo
$ sudo docker run --rm -ti -v "$(realpath .):/app" --user $(id -u $USER):$(id -g $USER) ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest
root@656be163fe84:/app# BOLOS_SDK=$NANOSP_SDK make
```

## Load the app on a physical device

:warning: Only Nano S and Nano S+ devices allow application side-loading. This section will not work with a Nano X.

To load the app from the container, you will need additional docker arguments in order to allow Docker to access your USB port.
Your physical device must be connected, unlocked and the screen showing the dashboard (not inside an application).
Use the following docker command:

```bash
$ sudo docker run --rm -ti  -v "$(realpath .):/app" --privileged -v "/dev/bus/usb:/dev/bus/usb" --user $(id -u $USER):$(id -g $USER) ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest
root@656be163fe84:/app# BOLOS_SDK=$NANOS_SDK make load
```

## Build the container image

### Standard Build

Container can be build using standard tools:

```bash
# Docker
$ (cd full && sudo docker build -t ledger-app-builder:latest .)
# Podman (from https://podman.io/)
$ (cd full && podman build -t ledger-app-builder:latest .)
# Buildah (from https://buildah.io/)
$ (cd full && buildah bud -t ledger-app-builder:latest .)
```

### App Scanner

Image can embed the [Coverity Scan](https://scan.coverity.com/) build tool. It is an excellent static analysis tool, and it can be very useful to find bugs in Nano apps.

The build tool must be downloaded before building the image. Archive can be downloaded from <https://scan.coverity.com/download>. Download is available to everyone, but it requires to create an account. After having registered, download Coverity Build Tool 2021.12 for Linux64 and place the downloaded archive in the `coverity` directory.

Then, build container from the `coverity/` directory with:

```bash
# Docker
$ (cd full && sudo docker build -t ledger-app-scanner:latest .)
# Podman (from https://podman.io/)
$ (cd full && podman build -t ledger-app-scanner:latest .)
# Buildah (from https://buildah.io/)
$ (cd full && buildah bud -t ledger-app-scanner:latest .)
```
