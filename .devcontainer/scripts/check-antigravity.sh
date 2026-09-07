#!/usr/bin/env bash
set -Eeuo pipefail

# Verify the Antigravity CLI is usable and report whether a login is needed.
#
# The `agy` binary is installed into /usr/local/bin by Dockerfile.debian, so
# nothing is downloaded here. Credentials live in ~/.gemini, which is a named
# Docker volume - log in once and it survives every later rebuild.

if ! command -v agy >/dev/null 2>&1; then
  echo "Error: 'agy' not found on PATH. Rebuild the image without cache." >&2
  exit 1
fi

mkdir -p "${HOME}/.gemini"

echo "Antigravity CLI: $(command -v agy)"

if [ -s "${HOME}/.gemini/jetski-standalone-oauth-token" ]; then
  echo "Credentials found in ~/.gemini - no login required."
else
  echo "No credentials yet. Run 'agy' once and sign in;"
  echo "the token persists in the ~/.gemini volume across rebuilds."
fi
