{ ... }:
{
  flake.modules.homeManager.atuin =
    { ... }:
    {
      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          # Sync settings (optional - requires account at atuin.sh or self-hosted)
          auto_sync = false; # Set to true if you want to sync across machines

          # Search settings
          search_mode = "fuzzy"; # fuzzy, exact, prefix, fulltext, skim
          filter_mode = "global"; # global, host, session, directory
          style = "compact"; # compact, full, auto
          inline_height = 20;

          # UI settings
          show_preview = true;
          show_help = true;
          exit_mode = "return-original"; # return-original, return-query

          # Keybindings
          keymap_mode = "vim-normal"; # emacs, vim-normal, vim-insert

          # Stats
          common_subcommands = [
            "cargo"
            "git"
            "npm"
            "yarn"
            "kubectl"
            "docker"
          ];

          # Advanced
          update_check = false;
          enter_accept = true;
        };
      };
    };
}
