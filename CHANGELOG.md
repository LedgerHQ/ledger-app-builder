# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.34.0] - 2024-08-13

### Changed
    - Bump Speculos version
    - Bump Flex and Stax SDK versions

## [3.33.0] - 2024-07-30

### Changed
    - Bump cargo-ledger version

## [3.32.0] - 2024-07-30

### Changed
    - Bump Ragger version
    - Bump cargo-ledger version

## [3.31.0] - 2024-07-25

### Changed
    - Bump Flex and Stax SDK versions

## [3.30.0] - 2024-07-17

### Changed
    - Bump all devices SDK version

## [3.29.0] - 2024-07-16

### Changed
    - Bump Flex and Stax SDK versions
    - Bump Ragger version

## [3.28.0] - 2024-07-11

### Changed
    - Bump Flex and Stax SDK versions
    - Bump Ragger version

## [3.27.0] - 2024-07-04

### Changed
    - dev-tools : bump Speculos and Ragger versions

## [3.26.0] - 2024-07-03

### Changed
    - Bump Flex and Stax SDK versions

## [3.25.2] - 2024-06-19

### Changed
    - Bump Speculos and Ragger versions

## [3.25.1] - 2024-06-14

### Changed
    - Bump Flex SDK version

## [3.25.0] - 2024-06-12

### Changed
    - Bump all devices SDK version

## [3.24.3] - 2024-06-04

### Changed
    - full: Bump cargo-ledger version to 1.4.1

## [3.24.2] - 2024-05-27

### Changed
    - full: Bump cargo-ledger version to 1.4.0 and ledgerwallet version to 0.5.0.

## [3.24.1] - 2024-05-24

### Changed
    - legacy: Declare missing FLEX_SDK

## [3.24.0] - 2024-05-21

### Changed
    - lite: Bump Ledgerblue version to 0.1.54

## [3.23.0] - 2024-05-15

### Changed
    - Bump all devices SDK version
    - dev-tools: Bump Ragger version to 1.19.0 and Speculos to 0.9.1 (enabling Flex swipe)

## [3.22.1] - 2024-05-15

### Fixed
    - Unit tests regression (lcov)

## [3.22.0] - 2024-05-13

### Changed
    - Bump LNS to lns-2.1.0-v20.0

## [3.21.0] - 2024-04-23

### Changed
    - Bump all devices SDK version

## [3.20.0] - 2024-04-12

### Changed
    - Bump Flex SDK version
    - dev-tools: Bump Ragger version to 1.18.0 (enabling Flex testing) and Speculos to 0.8.6

## [3.19.0] - 2024-04-03

### Added
    - Flex target

### Changed
    - dev-tools: Bump Ragger version to 1.16+

## [3.18.0] - 2024-03-27

### Changed
    - Bump SDK versions with last patchs
    - dev-tools: Bump Ragger version to 1.16.0

## [3.17.0] - 2024-02-21

### Changed
    - Bump Stax SDK version to target stax_1.4.0-rc2
    - Bump SDK version with last patchs
    - dev-tools: Bump Ragger version to 1.14.4

## [3.16.1] - 2024-02-09

### Changed
    - [dev-tools] : specify latest version of Ragger.

## [3.16.0] - 2024-02-08

### Changed
    - Bump Nano S SDK version

## [3.15.1] - 2024-02-05

### Changed
    - [full, legacy, dev-tools] Bump cargo-ledger version (1.3.0)

## [3.15.0] - 2024-01-25

### Changed
    - Bump SDK versions

## [3.14.0] - 2024-01-23

### Changed
    - [full, legacy, dev-tools] Default Rust toolchain set to stable 1.75.0

## [3.13.0] - 2024-01-18

### Changed
    - [legacy] Install proper ARM toolchain with regards to current arch (amd64 or arm64)
    - [full, legacy, dev-tools] Update Rust nightly in full and legacy containers

## [3.12.3] - 2024-01-15
    - Update cargo-ledger to version 1.2.3

## [3.12.2] - 2024-01-11

### Changed
    - Add force rebase workflow

## [3.12.1] - 2024-01-11

### Changed
    - Update cargo-ledger

## [3.12.0] - 2024-01-10

### Changed
    - Bump Nano S + SDK version for OS 1.1.1 support

## [3.11.1] - 2024-01-03

### Changed
    - Bump tj-actions/changed-files from 33 to 41 in .github/workflows

## [3.11.0] - 2023-12-11

### Added
    - Add ledgerctl to full and legacy images so that we can use cargo ledger sideload and apdu dump features.

### Changed
    - Lock installed version of cargo-ledger in full and legacy images.
    - Bump Stax SDK version in lite image.

## [3.10.2] - 2023-12-07

### Changed
    - Bump LNS+ SDK version

## [3.10.1] - 2023-12-07

### Changed
    - Bump SDK versions

## [3.10.0] - 2023-12-07

### Changed
    - Bump SDK versions

## [3.9.2] - 2023-11-30

### Changed
    - Configure cargo to use sparse registry protocol to gather dependencies during a build (faster)

## [3.9.1] - 2023-11-17

### Changed
    - Update NanoX target to last prod OS - no API_LEVEL change
    - Bump cargo ledger version to 1.1.1

## [3.9.0] - 2023-10-25

### Added
    - Add a Cargo config global file in full image

## [3.8.0] - 2023-10-09

### Added
    - Add `jq` to lite image

## [3.7.0] - 2023-10-09

### Changed
    - Bump SDK versions

## [3.6.0] - 2023-10-03

### Added
    - Add `cargo ledger setup` step in full/legacy images so users don't have to do it.

### Changed
    - Update curl installation step in full image (work around of https://github.com/curl/curl/issues/11917).
    - Remove curl installation from dev-tools image (already installed in full image).

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
    - Use directly pypi.org instead of test.pypi.org for Ragger

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
