{ config, pkgs, username, ... }: {
  imports = [ ./shared.nix ];

  home.username      = username;
  home.homeDirectory = "/home/${username}";

  # Required for Home Manager on non-NixOS Linux
  targets.genericLinux.enable = true;

}
