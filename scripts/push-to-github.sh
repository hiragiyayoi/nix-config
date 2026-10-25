#!/usr/bin/env bash
# Push nix-config to GitHub.
# Usage: ./scripts/push-to-github.sh <github-username> [repo-name]
# Example: ./scripts/push-to-github.sh myuser nix-config
set -euo pipefail

GH_USER="${1:?Usage: $0 <github-username> [repo-name]}"
REPO_NAME="${2:-nix-config}"
REMOTE_URL="git@github.com:${GH_USER}/${REPO_NAME}.git"

cd "$(dirname "$0")/.."

# Ensure SSH key exists
if [ ! -f "${HOME}/.ssh/id_ed25519" ]; then
  echo "No SSH key found. Generate one first:"
  echo "  ssh-keygen -t ed25519 -C \"your@email\" -f ~/.ssh/id_ed25519 -N \"\""
  exit 1
fi

# Set (or update) remote
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "${REMOTE_URL}"
else
  git remote add origin "${REMOTE_URL}"
fi

echo "Remote 'origin' set to: ${REMOTE_URL}"
echo ""
echo "Before pushing, make sure you have:"
echo "  1. Created the repository '${REPO_NAME}' on GitHub (empty, no README)."
echo "  2. Added your SSH public key to GitHub:"
echo "     cat ~/.ssh/id_ed25519.pub"
echo "     -> https://github.com/settings/keys"
echo ""
echo "Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>&1 | grep -qi "successfully authenticated"; then
  echo "SSH auth OK. Pushing..."
  git push -u origin main
else
  echo "SSH authentication not ready yet. Add the key to GitHub, then run:"
  echo "  git push -u origin main"
fi
