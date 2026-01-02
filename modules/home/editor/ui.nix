{ ... }:
{
  # UI: Colorscheme, Statusline, Snacks
  flake.modules.homeManager.neovim-ui = {
    programs.nixvim = {
      colorschemes.dracula = {
        enable = true;
      };

      plugins.lualine = {
        enable = true;
        settings.options = {
          theme = "auto";
          globalstatus = true;
          component_separators = { left = "│"; right = "│"; };
          section_separators = { left = ""; right = ""; };
        };
      };

      plugins.snacks = {
        enable = true;
        settings = {
          # UI
          notifier.enabled = true;
          statuscolumn.enabled = true;
          indent.enabled = true;
          scroll.enabled = true;

          # Performance
          bigfile.enabled = true;
          quickfile.enabled = true;
          words.enabled = true;
        };
      };
    };
  };
}
