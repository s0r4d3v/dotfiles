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

      plugins.mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          icons = { };
          starter = {
            header = ''
              ▄▄   ▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄   ▄ ▄▄   ▄▄
              █  █▄█  █  ▄    █       █  █ █  █   █ █ █  █ █  █
              █       █ █ █   █▄▄▄▄   █  █ █  █   █▄█ █  █ █  █
              █       █ █ █   █▄▄▄▄█  █  █▄█  █      ▄█  █▄█  █
              █       █ █▄█   █ ▄▄▄▄▄▄█       █     █▄█       █
              █ ██▄██ █       █ █▄▄▄▄▄█       █    ▄  █       █
              █▄█   █▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄█ █▄█▄▄▄▄▄▄▄█
            '';
            evaluate_single = true;
          };
        };
      };

      plugins.snacks = {
        enable = true;
        settings = {
          notifier.enabled = true;
          statuscolumn.enabled = true;
          indent.enabled = true;
          scroll.enabled = true;
        };
      };
    };
  };
}
