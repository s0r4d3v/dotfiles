{ ... }:
{
  flake.modules.homeManager.messaging =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = with pkgs; [
        discord
        slack
        zoom-us
      ];

      # Discord settings notes:
      # - Discord stores settings in ~/Library/Application Support/discord/ (macOS)
      # - Settings are managed through the app UI, not declaratively
      # - For privacy: Settings > Privacy & Safety > disable telemetry options

      # Slack settings notes:
      # - Slack stores settings in ~/Library/Application Support/Slack/ (macOS)
      # - Keyboard shortcuts: Preferences > Accessibility
      # - Recommended: Enable "Dark Mode" in Preferences > Themes

      # Zoom privacy & security settings (configure in app):
      # - Settings > Video: Disable "HD" if bandwidth is limited
      # - Settings > Audio: Test speaker and microphone
      # - Settings > General: Disable "Add Zoom to macOS menu bar"
      # - Settings > Privacy: Review camera/microphone permissions
      #
      # For enterprise: SSO settings are configured through the app
    };
}
