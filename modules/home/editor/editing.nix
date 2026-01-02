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
        settings = {
          default_file_explorer = true;
          keymaps = {
            "\\" = "actions.close";
          };
        };
      };

      plugins.mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          # UI
          icons = { };

          # Editing
          surround = { };
          pairs = { };
          comment = { };
          bufremove = { };
          splitjoin = { };
          move = { };
          ai = { };

          # Dashboard (start screen)
          starter = { };
        };
      };

      plugins.snacks = {
        enable = true;
        settings = {
          # Features
          picker.enabled = true;
          lazygit.enabled = true;
          terminal.enabled = true;
          git.enabled = true;
        };
      };

      plugins.which-key = {
        enable = true;
        settings.delay = 200;
      };
    };
  };
}
