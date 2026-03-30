{ config, pkgs, username, ... }: {
  imports = [ ./shared.nix ];

  home.username      = username;
  home.homeDirectory = "/Users/${username}";

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

}
