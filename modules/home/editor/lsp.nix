{ ... }:
{
  # LSP, Completion, Lint, Format, Diagnostics
  flake.modules.homeManager.neovim-lsp = { pkgs, ... }: {
    home.packages = with pkgs; [
      # LSP servers
      pyright
      nil
      marksman
      # Linters and formatters
      ruff
      statix
      markdownlint-cli
      nixfmt
      nodePackages.prettier
    ];

    programs.nixvim = {
      plugins.lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          nil_ls.enable = true;
          marksman.enable = true;
        };
      };

      diagnostic = {
        settings = {
          virtual_text = true;
        };
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
        settings = {
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
          formatters_by_ft = {
            python = [ "ruff_format" ];
            nix = [ "nixfmt" ];
            markdown = [ "prettier" ];
          };
        };
      };

      plugins.trouble = {
        enable = true;
        settings.auto_close = true;
      };

    };
  };
}
