{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    # Identity is intentionally left unset here; configure per-machine or via
    # ~/.config/git/config.local if needed.
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
