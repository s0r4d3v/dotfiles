{ pkgs, username, ... }: {

  # ===========================================================================
  # Homebrew — casks only (CLI tools are managed by Nix/Home Manager)
  # ===========================================================================
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "claude"
      "google-chrome"
      "zoom"
      "zotero"
    ];
    # Remove casks not listed here on next darwin-rebuild switch
    onActivation.cleanup = "zap";
  };

  # ===========================================================================
  # Fonts
  # ===========================================================================
  fonts.packages = [
    pkgs.maple-mono.NF-CN  # Maple Mono Nerd Font with Chinese + ligatures
  ];

  # ===========================================================================
  # Nix
  # ===========================================================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ===========================================================================
  # Users
  # ===========================================================================
  users.users.${username} = {
    home = "/Users/${username}";
  };

  # ===========================================================================
  # System
  # ===========================================================================
  system.primaryUser = username;
  system.stateVersion = 6;
}
