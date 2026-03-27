{ config, pkgs, username, ... }: {
  imports = [ ./shared.nix ];

  home.username      = username;
  home.homeDirectory = "/Users/${username}";

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.zsh.shellAliases = {
    ls = "ls -G";
  };
}
