{ config, pkgs, ... }: {
  imports = [ ./shared.nix ];

  home.username    = "soranagano";
  home.homeDirectory = "/Users/soranagano";

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.zsh.shellAliases = {
    ls = "ls -G";
  };
}
