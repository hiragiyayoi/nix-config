#!/usr/bin/env bash
# Push nix-config to GitHub using gh CLI.
# Usage: ./scripts/push-to-github.sh [repo-name] [visibility]
# Examples:
#   ./scripts/push-to-github.sh nix-config public
#   ./scripts/push-to-github.sh my-nix-config private
set -euo pipefail

REPO_NAME="${1:-nix-config}"
VISIBILITY="${2:-public}"

cd "$(dirname "$0")/.."

# --- ensure gh is available ---
if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: gh (GitHub CLI) is not installed."
  echo "Install via Nix: home-manager switch (github-cli is in dev.nix)"
  echo "Or: nix run nixpkgs#github-cli -- auth login"
  exit 1
fi

# --- ensure authenticated ---
if ! gh auth status >/dev/null 2>&1; then
  echo "Not authenticated with GitHub. Starting gh auth login..."
  gh auth login --git-protocol ssh --hostname github.com
fi

GH_USER="$(gh api user --jq .login)"
echo "Authenticated as: ${GH_USER}"

# --- create repo if it doesn't exist ---
if ! gh repo view "${GH_USER}/${REPO_NAME}" >/dev/null 2>&1; then
  echo "Creating repository ${GH_USER}/${REPO_NAME} (${VISIBILITY})..."
  gh repo create "${REPO_NAME}" --"${VISIBILITY}" --source=. --remote=origin --push
else
  echo "Repository ${GH_USER}/${REPO_NAME} already exists."
  # Ensure remote is set
  if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "git@github.com:${GH_USER}/${REPO_NAME}.git"
  fi
  echo "Pushing to origin..."
  git push -u origin main
fi

echo ""
echo "Done. Repository URL: https://github.com/${GH_USER}/${REPO_NAME}"

