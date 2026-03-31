{ config, pkgs, username, ... }: {
  imports = [ ./shared.nix ];

  home.username      = username;
  home.homeDirectory = "/Users/${username}";

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # ===========================================================================
  # Karabiner-Elements — keyboard remapping
  #   Esc        → send Esc + switch to English input
  #   Caps Lock  → toggle English ↔ Japanese (Romaji) input
  # ===========================================================================
  xdg.configFile."karabiner/karabiner.json" = {
    source = ../config/.config/karabiner/karabiner.json;
  };

  xdg.configFile."ghostty/config" = {
    source = ../config/.config/ghostty/config;
    force  = true;
  };

}
