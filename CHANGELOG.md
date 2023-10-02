# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.5.1] - 2023-10-02

### Changed
    - legacy: support multi arch (amd64/arm64) builds

## [3.5.0] - 2023-09-18

### Changed
    - Use Rust nightly toolchain as default

## [3.4.0] - 2023-09-15

### Changed
    - Bump Stax SDK versions
    - Bump Rust stable version to 1.72.0

### Added
    - cargo-ledger version 1.1.0
    - llvm15 tools

## [3.3.0] - 2023-09-01

### Changed
    - Bump SDK versions

## [3.2.9] - 2023-08-18

### Changed
    - Bump SDK versions

## [3.2.8] - 2023-08-09

### Fixed
    - devtools: removed the Python dependencies deletion
    - README: more instructions on Boilerplate testing

## [3.2.7] - 2023-08-09

### Changed
    - Add mesa-dri-gallium package to dev-tools docker

## [3.2.6] - 2023-08-02

### Changed
    - Use directly pypi.org instead of test.pypi.org for ragger

## [3.2.5] - 2023-07-28

### Changed
    - Bump NanoX & Stax SDK versions

## [3.2.4] - 2023-07-21

### Changed
    - devtools : keep musl-dev and install curl for cargo ledger compatibility.

### Fixed
    - CI : search if last changelog version exists in tags of all pushed images (full, legacy, lite, dev-tools), not just app-builder.

## [3.2.3] - 2023-07-07

### Changed
    - Add fonts to devtools image so that fonts in Qt apps are properly displayed.

## [3.2.2] - 2023-06-29

### Changed
    - Bump NanoX SDK version

## [3.2.1] - 2023-06-27

### Changed
    - Add gzip package for Lcov

## [3.2.0] - 2023-06-23

### Changed
    - Bump SDK versions

## [3.1.0] - 2023-06-19

### Changed
    - Legacy image : Rust : freeze stable version and add nightly version. Add rust-src for nightly version.

## [3.0.0] - 2023-06-19

### Changed
    - Full image : Rust : freeze stable version and add nightly version. Add rust-src for nightly version.
    - Add changelog file.
