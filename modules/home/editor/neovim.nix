{ ... }:
{
  # Neovim Core: Enable, globals, opts, clipboard
  flake.modules.homeManager.neovim = { pkgs, ... }: {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      opts = {
        # mouse
        mouse = "";
        # Line numbers
        number = true;
        relativenumber = true;

        # Indentation
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;

        # Undo
        undofile = true;

        # Search
        ignorecase = true;
        smartcase = true;

        # UI
        termguicolors = true;
        signcolumn = "yes";
        cursorline = true;
        wrap = false;
        scrolloff = 8;
        sidescrolloff = 8;

        # Splits
        splitright = true;
        splitbelow = true;

        # Performance
        updatetime = 250;
        timeoutlen = 300;
      };

      # Clipboard (with SSH/OSC52 support)
      clipboard.register = "unnamedplus";
      extraConfigLua = ''
        if vim.env.SSH_TTY then
          vim.g.clipboard = {
            name = 'OSC 52',
            copy = {
              ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
              ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
            },
            paste = {
              ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
              ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
            },
          }
        end
      '';
    };
  };
}
