{ ... }:
{
  flake.modules.homeManager.slack = { pkgs, ... }: {
    home.packages = [ pkgs.slack ];

    # Slack settings notes:
    # - Slack stores settings in ~/Library/Application Support/Slack/ (macOS)
    # - Keyboard shortcuts: Preferences > Accessibility
    # - Recommended: Enable "Dark Mode" in Preferences > Themes
  };
}
