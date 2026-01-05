{ ... }:
{
  # LSP, Completion, Lint, Format, Diagnostics
  flake.modules.homeManager.neovim-lsp = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Copilot dependencies
      nodejs
      # LSP servers
      pyright
      nil
      marksman
      tinymist
      vue-language-server
      haskell-language-server
      # Haskell compiler for LSP
      ghc
      # Linters
      ruff
      statix
      markdownlint-cli
      eslint
      hlint
      # Formatters
      ormolu
      prettierd
      typstyle
      nixfmt-rfc-style
    ];

    programs.nixvim = {
      filetype = {
        extension = {
          qmd = "quarto";
        };
      };

      plugins.lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          nil_ls.enable = true;
          marksman = {
            enable = true;
            filetypes = ["markdown" "quarto"];
          };
          tinymist.enable = true;
          vue_ls.enable = true;
          hls = {
            enable = true;
            installGhc = false;
          };
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
          quarto = [ "markdownlint" ];
          javascript = [ "eslint" ];
          typescript = [ "eslint" ];
          vue = [ "eslint" ];
          haskell = [ "hlint" ];
        };
      };

      plugins.conform-nvim = {
        enable = true;
        settings = {
          # format_on_save = {
          #   lsp_fallback = true;
          #   timeout_ms = 2000;
          # };
          formatters_by_ft = {
            python = [ "ruff_format" ];
            nix = [ "nixfmt" ];
            markdown = [ "prettierd" ];
            quarto = [ "prettierd" ];
            typst = [ "typstyle" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            vue = [ "prettierd" ];
            haskell = [ "ormolu" ];
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
