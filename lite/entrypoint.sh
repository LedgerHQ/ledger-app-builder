#!/usr/bin/env bash
set -euo pipefail

# If RUN_AS_ROOT is set, skip user creation and run as root
if [ "${RUN_AS_ROOT:-}" = "true" ]; then
  exec "$@"
fi

# Defaults if not provided
HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"
USER_NAME="${USER_NAME:-dev}"

# ensure group exists with HOST_GID
if getent group "${HOST_GID}" >/dev/null 2>&1; then
  # Group with this GID already exists, get its name
  GROUP_NAME=$(getent group "${HOST_GID}" | cut -d: -f1)
elif getent group "${USER_NAME}" >/dev/null 2>&1; then
  # Group with this name exists, use it
  GROUP_NAME="${USER_NAME}"
else
  # Create new group
  groupadd -g "${HOST_GID}" "${USER_NAME}"
  GROUP_NAME="${USER_NAME}"
fi

# create or remap user
if id -u "${USER_NAME}" >/dev/null 2>&1; then
  usermod -u "${HOST_UID}" -g "${HOST_GID}" "${USER_NAME}"
else
  useradd -l -m -u "${HOST_UID}" -g "${HOST_GID}" -s /bin/bash "${USER_NAME}" 2>&1 | grep -v "outside of the UID_MIN" || true
fi

# fix HOME ownership if it exists
if [ -d "/home/${USER_NAME}" ]; then
  chown -R "${HOST_UID}:${HOST_GID}" "/home/${USER_NAME}" || true
fi

# run as that user
exec gosu "${USER_NAME}" "$@"
