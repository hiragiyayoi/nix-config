# nix-config

Declarative home environment for `user` on Debian 13, managed with Nix + home-manager via a flake.

## Prerequisites
- Nix (multi-user daemon) installed; flakes enabled (`/etc/nix/nix.conf`).
- systemd available (nix-daemon service active).

## Bootstrap
```sh
cd ~/nix-config
nix flake check
home-manager switch --flake .#user
```

If `home-manager` is not on PATH yet:
```sh
nix run home-manager/release-26.05 -- switch --flake ~/nix-config#user
```

## Update
```sh
cd ~/nix-config
nix flake update
home-manager switch --flake .#user
```

## Rollback
```sh
home-manager generations
home-manager switch --flake ~/nix-config#user  # or pick a prior generation
```

## Notes
- Host OS remains Debian; only the user environment is managed by Nix.
- Channels: `nixos` -> nixos-26.05 (stable).

## Per-project dev shells
Copy `templates/dev-shell/` into a project, then:
```sh
cp -r ~/nix-config/templates/dev-shell /path/to/project
cd /path/to/project
direnv allow
```
The `.envrc` uses `use flake`, so entering the directory activates the dev shell automatically.

## Maintenance
- Automatic GC runs weekly (`nix.gc`), deleting generations older than 30 days.
- Manual: `nix-collect-garbage -d` or `nix store gc`.

## GitHub management (via gh CLI)

All GitHub operations use `gh` (GitHub CLI), which is installed via Nix (`github-cli` in `modules/dev.nix`).

### Authenticate with GitHub

```sh
gh auth login --git-protocol https --hostname github.com
```

This uses device flow: open the URL shown, enter the one-time code, and authorize. The SSH key at `~/.ssh/id_ed25519` is used automatically.

Check status:
```sh
gh auth status
```

### Push this repo to GitHub

```sh
cd ~/nix-config
./scripts/push-to-github.sh [repo-name] [public|private]
```

This script:
1. Checks `gh` auth (runs `gh auth login` if needed)
2. Creates the repo on GitHub if it doesn't exist (`gh repo create`)
3. Pushes `main` branch

Or manually with gh:
```sh
gh repo create nix-config --public --source=. --remote=origin --push
```

### SSH public key (this machine)

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDsVKu7eywPtL2MtEsCouzedktaGqxOU/BVnEWCav3ko user@proxmoxmcp-dev
```

### Apply on another machine

```sh
# 1. Install Nix (multi-user daemon) if not present
sh <(curl -L https://nixos.org/nix/install) --daemon

# 2. Clone via gh and bootstrap
gh auth login --git-protocol https
gh repo clone <user>/nix-config ~/nix-config
cd ~/nix-config
./scripts/bootstrap.sh <user>/nix-config [username]
```

The bootstrap script supports gh shorthand (`user/repo`), full URLs, and SSH URLs.

### SSH public key (this machine)

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDsVKu7eywPtL2MtEsCouzedktaGqxOU/BVnEWCav3ko user@proxmoxmcp-dev
```
