{ ... }:
{
  flake.modules.homeManager.discord = { pkgs, ... }: {
    home.packages = [ pkgs.discord ];

    # Discord settings notes:
    # - Discord stores settings in ~/Library/Application Support/discord/ (macOS)
    # - Settings are managed through the app UI, not declaratively
    # - For privacy: Settings > Privacy & Safety > disable telemetry options
  };
}
