#!/usr/bin/env bash
# Bootstrap script: clone nix-config and apply home-manager configuration.
# Usage:
#   ./bootstrap.sh [REPO_URL] [USERNAME]
# Examples:
#   ./bootstrap.sh git@github.com:YOURUSER/nix-config.git
#   ./bootstrap.sh https://github.com/YOURUSER/nix-config.git alice

set -euo pipefail

REPO_URL="${1:-}"
USERNAME="${2:-${USER:-user}}"
TARGET_DIR="${HOME}/nix-config"

# --- sanity checks ---
if ! command -v nix >/dev/null 2>&1; then
  echo "ERROR: Nix is not installed. Install Nix (multi-user daemon) first:"
  echo "  sh <(curl -L https://nixos.org/nix/install) --daemon"
  exit 1
fi

if ! nix --version >/dev/null 2>&1; then
  echo "ERROR: Nix is not usable. Source the daemon profile:"
  echo "  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  exit 1
fi

# --- clone (if repo url provided) ---
if [ -n "${REPO_URL}" ]; then
  if [ -d "${TARGET_DIR}/.git" ]; then
    echo "Repo already exists at ${TARGET_DIR}; pulling latest..."
    git -C "${TARGET_DIR}" pull --ff-only
  else
    echo "Cloning ${REPO_URL} into ${TARGET_DIR}..."
    git clone "${REPO_URL}" "${TARGET_DIR}"
  fi
fi

if [ ! -d "${TARGET_DIR}" ]; then
  echo "ERROR: ${TARGET_DIR} does not exist. Provide a REPO_URL or run from the repo dir."
  exit 1
fi

cd "${TARGET_DIR}"

# --- adjust username/home directory if different ---
if [ "${USERNAME}" != "user" ]; then
  echo "Adjusting username from 'user' to '${USERNAME}' in flake.nix and home.nix..."
  sed -i "s/username = \"user\";/username = \"${USERNAME}\";/" flake.nix
  sed -i "s/home.username = \"user\";/home.username = \"${USERNAME}\";/" home.nix 2>/dev/null || true
  sed -i "s#home.homeDirectory = \"/home/user\";#home.homeDirectory = \"/home/${USERNAME}\";#" home.nix 2>/dev/null || true
fi

# --- enable flakes (ensure nix.conf) ---
NIX_CONF="/etc/nix/nix.conf"
if [ -f "${NIX_CONF}" ]; then
  if ! grep -q "experimental-features" "${NIX_CONF}"; then
    echo "experimental-features = nix-command flakes" | sudo tee -a "${NIX_CONF}" >/dev/null
  fi
else
  echo "experimental-features = nix-command flakes" | sudo tee "${NIX_CONF}" >/dev/null
fi

# --- apply ---
echo "Running nix flake check..."
nix flake check

echo "Applying home-manager configuration for ${USERNAME}..."
if command -v home-manager >/dev/null 2>&1; then
  home-manager switch --flake ".#${USERNAME}"
else
  nix run home-manager/release-26.05 -- switch --flake ".#${USERNAME}"
fi

echo ""
echo "Done. Open a new shell or run: source ~/.profile"
echo "Tools installed under ~/.nix-profile/bin"
