#!/usr/bin/env bash
set -Eeuo pipefail
# Prerequisite: The .ssh files must be mounted to ~/.sshtemplate before running this script.
#  "source=${localEnv:HOME}/.ssh,target=/home/container-user/.sshtemplate,type=bind,readonly,consistency=cached"
# Copy all SSH files from template to ~/.ssh and set permissions

TEMPLATE_DIR="${HOME}/.sshtemplate"
SSH_DIR="${HOME}/.ssh"

if command -v tree >/dev/null 2>&1; then
  tree "${TEMPLATE_DIR}" || true
else
  ls -la "${TEMPLATE_DIR}" || true
fi

if [ ! -d "${TEMPLATE_DIR}" ]; then
  echo "Template dir not found: ${TEMPLATE_DIR}"
  exit 1
fi

if [ ! -f "${TEMPLATE_DIR}/config" ]; then
  echo "Can't find your ./sshtemplate/config file"
  exit 1
fi

mkdir -p "${SSH_DIR}" || {
  echo "ERROR: creating SSH dir failed" >&2
  exit 1
}
# Copy regular files, directories and symlinks only. The host's ~/.ssh can
# contain live ssh-agent sockets (e.g. ~/.ssh/agent/s.*), which cannot be
# copied and are meaningless inside the container anyway - copying everything
# blindly makes this script fail on an otherwise healthy setup.
skipped="$(find "${TEMPLATE_DIR}" -mindepth 1 ! -type f ! -type d ! -type l | wc -l | tr -d ' ')"

# Enumerate the copyable entries explicitly and feed them to tar, so sockets
# are never read and tar has no reason to warn or fail.
copy_status=0
if ! (
  cd "${TEMPLATE_DIR}" &&
    find . -mindepth 1 \( -type f -o -type d -o -type l \) -print0 |
    tar --null -T - -cf - 2>/dev/null
) | tar -C "${SSH_DIR}" -xf - 2>/dev/null; then
  copy_status=1
fi

# Verify by result rather than by exit status: the config file is the one
# thing this script exists to deliver.
if [ ! -f "${SSH_DIR}/config" ]; then
  echo "ERROR: copying SSH template failed (no config in ${SSH_DIR})" >&2
  exit 1
fi
if [ "${copy_status}" -ne 0 ]; then
  echo "NOTE: tar reported a non-fatal issue; ${SSH_DIR}/config is present, continuing."
fi

if [ "${skipped}" -gt 0 ]; then
  echo "Skipped ${skipped} non-regular file(s) (sockets/pipes) from the SSH template."
fi

chmod 700 "${SSH_DIR}"
find "${SSH_DIR}" -mindepth 1 -type d -exec chmod 700 {} + 2>/dev/null || true
find "${SSH_DIR}" -mindepth 1 -type f -exec chmod 600 {} + 2>/dev/null || true
echo "SSH files copied from .sshtemplate."
