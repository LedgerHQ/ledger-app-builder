#!/usr/bin/env bash
#
# script to run Guideline_enforcer checks
#

exeName=$(readlink -f "$0")

VERBOSE=false
IS_RUST=false

# All available checks (to be updated from the ledger-app-workflows repository)
ALL_CHECKS="icons app_load_params makefile readme scan"

APP_MANIFEST="ledger_app.toml"

#===============================================================================
#
#     help - Prints script help and usage
#
#===============================================================================
# shellcheck disable=SC2154  # var is referenced but not assigned
help() {
    echo
    echo "Usage: ${exeName} <options>"
    echo
    echo "Options:"
    echo
    echo "  -c <check>  : Requested check from (${ALL_CHECKS}). Default is all."
    echo "  -d <dir>    : Database directory"
    echo "  -w <dir>    : Workflows directory"
    echo "  -a <dir>    : Application directory"
    echo "  -b <dir>    : Application build directory"
    echo "  -t <device> : Targeted device"
    echo "  -g <ref>    : Git reference to clone ledger-app-workflows repository"
    echo "  -v          : Verbose mode"
    echo "  -h          : Displays this help"
    echo
    exit 1
}

#===============================================================================
#
#     Parsing parameters
#
#===============================================================================

while getopts ":a:b:c:d:w:t:g:vh" opt; do
    case ${opt} in
        a)  APP_DIR=${OPTARG}         ;;
        b)  BUILD_DIR=${OPTARG}       ;;
        c)  REQUESTED_CHECK=${OPTARG} ;;
        d)  DATABASE_DIR=${OPTARG}    ;;
        w)  WORKFLOW_DIR=${OPTARG}    ;;
        t)  TARGET=${OPTARG}          ;;
        g)  GIT_REF=(-b "${OPTARG}")  ;;
        v)  VERBOSE=true ;;
        h)  help ;;

        \?) echo "Unknown option: -${OPTARG}" >&2; exit 1;;
        : ) echo "Missing option argument for -${OPTARG}" >&2; exit 1;;
        * ) echo "Unimplemented option: -${OPTARG}" >&2; exit 1;;
    esac
done

#===============================================================================
#
#     Checking parameters
#
#===============================================================================

# Init verbose options
[[ ${VERBOSE} == false ]] && verbose_mode=(-q)

if [[ -z "${APP_DIR}" ]]; then
    if [[ -f /app/ledger_app.toml ]]; then
        APP_DIR="/app"
    elif [[ -f ./app-repository/ledger_app.toml ]]; then
        APP_DIR="./app-repository"
    elif [[ -f ./ledger_app.toml ]]; then
        APP_DIR=$(dirname "$(readlink -f .)")
    fi
fi

#===============================================================================
#
#     get_app_metadata - Retrieve application metadata from manifest
#
#===============================================================================
get_app_metadata() {
    if [[ ! -f "${APP_DIR}/${APP_MANIFEST}" ]]; then
        echo "/!\ No ${APP_MANIFEST} manifest detected in App directory ${APP_DIR}!"
        echo "This file is mandatory, please add it on your repository"
        echo "Documentation here: https://github.com/LedgerHQ/ledgered/blob/master/doc/utils/manifest.md"
        exit 1;
    fi

    # 'ledger_app.toml' exists
    echo "Manifest detected."
    # checking the manifest with the repo
    ledger-manifest --check "${APP_DIR}" "${APP_DIR}/${APP_MANIFEST}"

    # build directory
    if [[ -z "${BUILD_DIR}" ]]; then
        BUILD_DIR=$(ledger-manifest --output-build-directory "${APP_DIR}/${APP_MANIFEST}")
    fi

    # SDK language
    [[ "$(ledger-manifest --output-sdk "${APP_DIR}/${APP_MANIFEST}")" == "rust" ]] && IS_RUST=true
}

#===============================================================================
#
#     Main
#
#===============================================================================

get_app_metadata

if [[ -z "${WORKFLOW_DIR}" ]]; then
    # Clone the Worflows repository
    WORKFLOW_DIR="/tmp/ledger-app-workflows"
    if [[ ! -d "${WORKFLOW_DIR}" ]]; then
        git clone "${verbose_mode[@]}" https://github.com/LedgerHQ/ledger-app-workflows.git "${GIT_REF[@]}" "${WORKFLOW_DIR}"
    fi
fi

# Formatting the parameters
parameters=()
[[ -n "${REQUESTED_CHECK}" ]] && parameters+=(-c "${REQUESTED_CHECK}")
[[ -n "${DATABASE_DIR}" ]]    && parameters+=(-D "${DATABASE_DIR}")
[[ -n "${APP_DIR}" ]]         && parameters+=(-a "${APP_DIR}")
[[ -n "${BUILD_DIR}" ]]       && parameters+=(-b "${BUILD_DIR}")
[[ -n "${TARGET}" ]]          && parameters+=(-t "${TARGET}")
[[ "${IS_RUST}" == true ]] && parameters+=(-r)
[[ "${VERBOSE}" == true ]] && parameters+=(-v)

# Calling the workflow script with same parameters
"${WORKFLOW_DIR}"/scripts/check_all.sh "${parameters[@]}"
