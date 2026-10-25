{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    profileExtra = ''
      # Ensure Nix is available even if /etc/profile did not source it.
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi
    '';
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
    };
    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 10000;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
}
