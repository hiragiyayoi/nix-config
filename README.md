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
