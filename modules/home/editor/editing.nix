{ ... }:
{
  flake.modules.homeManager.neovim-editing = {
    programs.nixvim = {
      plugins.treesitter = {
        enable = true;
        settings.ensure_installed = [ "python" "nix" "markdown" "lua" "vim" "vimdoc" ];
      };

      plugins.flash = {
        enable = true;
        settings.modes.search.enabled = true;
      };

      plugins.oil = {
        enable = true;
        settings.default_file_explorer = true;
      };

      plugins.mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          icons = { };
          surround = { };
          pairs = { };
          comment = { };
          bufremove = { };
          splitjoin = { };
          move = { };
          ai = { };
        };
      };

      plugins.which-key = {
        enable = true;
        settings.delay = 200;
      };
    };
  };
}
