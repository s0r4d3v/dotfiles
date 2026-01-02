{ ... }:
{
  # LSP, Completion, Lint, Format, Diagnostics
  flake.modules.homeManager.neovim-lsp = {
    programs.nixvim = {
      plugins.lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          nil_ls.enable = true;
          marksman.enable = true;
        };
        settings = {
          diagnostics = {
            virtual_text = true;
          };
        }
      };

      plugins.blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "default";
          sources.default = [ "lsp" "path" "buffer" ];
          completion = {
            accept.auto_brackets.enabled = true;
            documentation.auto_show = true;
            ghost_text.enabled = true;
          };
          signature.enabled = true;
        };
      };

      plugins.lint = {
        enable = true;
        lintersByFt = {
          python = [ "ruff" ];
          nix = [ "statix" ];
          markdown = [ "markdownlint" ];
        };
      };

      plugins.conform-nvim = {
        enable = true;
        settings.formatters_by_ft = {
          python = [ "ruff_format" ];
          nix = [ "nixfmt" ];
          markdown = [ "prettier" ];
        };
      };

      plugins.trouble = {
        enable = true;
        settings.auto_close = true;
      };

    };
  };
}
