{ config, pkgs, ... }: {
  imports = [ ./shared.nix ];

  home.username    = "soranagano";  # change to your Linux username
  home.homeDirectory = "/home/soranagano";  # change accordingly

  # Required for Home Manager on non-NixOS Linux
  targets.genericLinux.enable = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.zsh.shellAliases = {
    ls = "ls --color=auto";
  };
}
