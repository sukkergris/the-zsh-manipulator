#!/usr/bin/env bash
#
# install-shellspec.sh
#
# Installs shellspec (https://shellspec.info/), the BDD test framework used
# by this project, via Homebrew. See CLAUDE.md for why shellspec was chosen
# over zunit.
#
# Usage:
#   ./scripts/install-shellspec.sh

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "error: Homebrew is required but was not found on PATH." >&2
  echo "       Install it from https://brew.sh/ and re-run this script." >&2
  exit 1
fi

if command -v shellspec >/dev/null 2>&1; then
  echo "shellspec is already installed: $(shellspec --version)"
  exit 0
fi

echo "Installing shellspec via Homebrew..."
brew install shellspec

if ! command -v shellspec >/dev/null 2>&1; then
  echo "error: shellspec was not found on PATH after installation." >&2
  echo "       Check 'brew doctor' and your PATH configuration." >&2
  exit 1
fi

echo "shellspec installed successfully: $(shellspec --version)"
