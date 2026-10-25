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
