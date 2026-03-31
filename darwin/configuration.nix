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
      "karabiner-elements"
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

  system.defaults = {
    NSGlobalDomain = {
      # Key repeat
      KeyRepeat                              = 2;     # fastest
      InitialKeyRepeat                       = 15;
      ApplePressAndHoldEnabled               = false; # disable accent popup → enables repeat in all apps
      # Appearance
      AppleInterfaceStyle                    = "Dark";
      AppleShowAllExtensions                 = true;
      # Disable autocorrections
      NSAutomaticSpellingCorrectionEnabled   = false;
      NSAutomaticCapitalizationEnabled       = false;
      NSAutomaticDashSubstitutionEnabled     = false;
      NSAutomaticQuoteSubstitutionEnabled    = false;
      # Scroll direction
      "com.apple.swipescrolldirection"       = false; # natural scroll off
    };

    dock = {
      autohide                = true;
      autohide-delay          = 0.0;
      autohide-time-modifier  = 0.2;
      show-recents            = false;
      tilesize                = 48;
    };

    finder = {
      AppleShowAllFiles       = true;   # show hidden files
      ShowPathbar             = true;
      ShowStatusBar           = true;
      FXDefaultSearchScope    = "SCcf"; # search current folder
      FXPreferredViewStyle    = "Nlsv"; # list view
    };

    screencapture = {
      location = "~/Desktop";
      type     = "png";
    };
  };
}
