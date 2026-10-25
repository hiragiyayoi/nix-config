{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core CLI utilities
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    ripgrep
    fd
    jq
    tree
    htop
    unzip
    zip
    curl
    wget
    file
    which

    # Build essentials
    gnumake
    gcc
    pkg-config

    # Languages / runtimes
    python3
    python3Packages.pip
    nodejs

    # VCS / tooling
    git
    github-cli
    direnv
  ];
}
