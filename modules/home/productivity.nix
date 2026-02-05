{ ... }:
{
  flake.modules.homeManager.productivity =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          discord
          slack
          zoom-us
          bitwarden-desktop
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          raycast
          brewCasks.notion
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          notion-app
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

      # Obsidian settings notes:
      # - Vault location: Choose a synced folder (iCloud, Dropbox, etc.)
      # - Recommended plugins (install via Community Plugins):
      #   - Vim mode: Enable in Settings > Editor > Vim key bindings
      #   - Git: For version control of notes
      #   - Dataview: For dynamic queries
      #   - Templater: For note templates
      #
      # Theme recommendations:
      # - Minimal Theme (clean, customizable)
      # - Things Theme (iOS-like design)
      #
      # Sync options:
      # - Obsidian Sync (paid, official)
      # - Git (free, manual/automated commits)
      # - iCloud/Dropbox (free, folder-based)
    };
}
