# Ledger Application Builder

This Docker image contains every dependencies to compile an application for the Nano S.

## Build the docker image

```
$ docker build -t ledger-app-builder:1.6.0 .
```

## Compile your app

In the source folder of your Nano S application:

```
$ docker run -ti -v $(realpath .):/app ledger-app-builder:1.6.0
root@656be163fe84:/# cd app/ && make
```
