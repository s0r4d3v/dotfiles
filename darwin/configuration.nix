{ pkgs, ... }: {

  # ===========================================================================
  # Homebrew — casks only (CLI tools are managed by Nix/Home Manager)
  # ===========================================================================
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "bitwarden"
    ];
    # Remove casks not listed here on next darwin-rebuild switch
    onActivation.cleanup = "zap";
  };

  # ===========================================================================
  # Nix
  # ===========================================================================
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ===========================================================================
  # Users
  # ===========================================================================
  users.users.soranagano = {
    home = "/Users/soranagano";
  };

  # ===========================================================================
  # System
  # ===========================================================================
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
