{ pkgs, username, ... }:
{

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
    onActivation.cleanup = "zap";
  };

  fonts.packages = [
    pkgs.maple-mono.NF-CN
  ];

  # ===========================================================================
  # Nix
  # ===========================================================================
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    home  = "/Users/${username}";
    shell = pkgs.zsh; # nix-darwin adds zsh to /etc/shells automatically
  };

  # Set login shell with fallback — runs as root so dscl works without password auth.
  # Prefers nix zsh; falls back to macOS built-in /bin/zsh if nix zsh is unavailable.
  system.activationScripts.setShell = {
    deps = [ "users" ]; # run after nix-darwin sets the shell, so we can override on fallback
    text = ''
      nix_zsh="${pkgs.zsh}/bin/zsh"
      if [[ -x "$nix_zsh" ]]; then
        desired="$nix_zsh"
      else
        desired="/bin/zsh"
        echo "warning: nix zsh not available, falling back to $desired"
      fi
      current=$(/usr/bin/dscl . -read /Users/${username} UserShell 2>/dev/null | /usr/bin/sed 's/UserShell: //')
      if [[ "$current" != "$desired" ]]; then
        /usr/bin/dscl . -create /Users/${username} UserShell "$desired"
      fi
    '';
  };

  system.primaryUser = username;
  system.stateVersion = 6;

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      "com.apple.swipescrolldirection" = true;
    };

    controlcenter = {
      BatteryShowPercentage = true;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleLanguages = [ "en-GB" ]; # language: English UK
        AppleLocale = "en_GB";
      };
      "com.apple.BezelServices" = {
        dAuto = false; # disable auto-adjust brightness
      };
      "com.apple.inputmethod.Kotoeri" = {
        JIMPrefLiveConversionKey = false; # disable live conversion (ライブ変換)
      };
    };

    CustomSystemPreferences = {
      "/Library/Preferences/com.apple.CoreBrightness" = {
        CBAdaptiveWhiteBalanceEnabled = 1; # True Tone
      };
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      show-recents = false;
      tilesize = 60;
    };

    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "Nlsv";
    };

    screencapture = {
      location = "~/Desktop";
      type = "png";
    };
  };
}
