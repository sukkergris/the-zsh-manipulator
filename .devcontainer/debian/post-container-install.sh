#!/usr/bin/env bash
# Runs once per container creation (devcontainer.json postCreateCommand).
#
# Only things that cannot be baked into the image belong here: files in
# $HOME, mounted volumes, and downloads too large for an image layer.
# Anything installable as a root apt package belongs in Dockerfile.debian.
set -u

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

WORKSPACE_DIR="/workspace"
SCRIPTS_DIR="$WORKSPACE_DIR/.devcontainer/scripts"

# Docker creates fresh volumes owned by root, which leaves the tools that own
# these directories unable to write to them. Must run before the steps below
# that write into ~/.ssh and ~/.gemini.
sudo chown -R container-user:container-user \
  "$HOME/.claude" \
  "$HOME/.continue" \
  "$HOME/.config/gh" \
  "$HOME/.gemini" \
  "$HOME/.ssh" \
  "$HOME/.sshtemplate" 2>/dev/null || true

# VS Code's Dev Containers extension copies the host's ~/.gitconfig into the
# container on (re)build. That gitconfig has no safe.directory entry for the
# workspace, so Git refuses to operate on the repo ("detected dubious
# ownership") whenever ownership/UID mapping looks even slightly off across
# the bind mount.
git config --global --add safe.directory "$WORKSPACE_DIR" || true

bash "$SCRIPTS_DIR/copy-ssh-files.sh"
bash "$SCRIPTS_DIR/remove-userkeychain.sh" "$HOME/.ssh/config"
bash "$SCRIPTS_DIR/install-global-npm-tools.sh"

# The Antigravity CLI (`agy`) is baked into the image by Dockerfile.debian.
# This only reports whether a login is still needed: credentials live in
# ~/.gemini, a named volume, so signing in once survives later rebuilds.
bash "$SCRIPTS_DIR/check-antigravity.sh"

echo "Post container install script done running"
