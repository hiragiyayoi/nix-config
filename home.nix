{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/dev.nix
    ./modules/direnv.nix
    ./modules/nix.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "26.05";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Basic session variables
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
