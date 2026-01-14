{ ... }:
{
  flake.modules.homeManager.obsidian =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = [ pkgs.obsidian ];

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
