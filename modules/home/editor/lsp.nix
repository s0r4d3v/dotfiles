{ ... }:
{
  # LSP, Completion, Lint, Format, Diagnostics
  flake.modules.homeManager.neovim-lsp =
    { pkgs, ... }:
    {
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
        texlab
        # Haskell compiler for LSP
        ghc
        # Linters
        ruff
        ty
        statix
        markdownlint-cli
        eslint
        hlint
        texlivePackages.chktex
        # Formatters
        ormolu
        prettierd
        typstyle
        nixfmt-rfc-style
        texlivePackages.latexindent
        bibtex-tidy
      ];

      programs.nixvim = {
        filetype = {
          extension = {
            qmd = "quarto";
          };
        };

        plugins = {
          treesitter = {
            enable = true;
            settings = {
              highlight = {
                enable = true;
                disable = ["latex"];
              };
              ensure_installed = [
                "python"
                "nix"
                "markdown"
                "lua"
                "vim"
                "vimdoc"
                "r"
                "julia"
                "bash"
                "html"
                "css"
                # "quarto"
              ];
            };
          };

          lsp = {
            enable = true;
            servers = {
              pyright.enable = true;
              nil_ls.enable = true;
              marksman = {
                enable = true;
                filetypes = [
                  "markdown"
                  "quarto"
                ];
              };
              tinymist.enable = true;
              vue_ls.enable = true;
              hls = {
                enable = true;
                installGhc = false;
              };
              html.enable = true;
              cssls.enable = true;
              texlab = {
                enable = true;
                settings = {
                  texlab = {
                    chktex = {
                      onOpenAndSave = true;
                    };
                    bibtexFormatter = "texlab";
                    latexFormatter = "latexindent";
                  };
                };
              };
            };
          };

          blink-cmp = {
            enable = true;
            settings = {
              keymap.preset = "default";
              sources = {
                default = [
                  "lsp"
                  "path"
                  "snippets"
                  # "buffer"
                ];
              };
              snippets.preset = "luasnip";
              completion = {
                accept.auto_brackets.enabled = true;
                documentation.auto_show = true;
                ghost_text.enabled = true;
              };
              signature.enabled = true;
            };
          };

          lint = {
            enable = true;
            lintersByFt = {
              python = [
                "ruff"
                "ty"
              ];
              nix = [ "statix" ];
              markdown = [ "markdownlint" ];
              quarto = [ "markdownlint" ];
              javascript = [ "eslint" ];
              typescript = [ "eslint" ];
              vue = [ "eslint" ];
              haskell = [ "hlint" ];
            };
            autoCmd = {
              event = [
                "BufWritePost"
                "BufEnter"
              ];
            };
          };

          conform-nvim = {
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
                html = [ "prettierd" ];
                css = [ "prettierd" ];
                tex = [ "latexindent" ];
                bib = [ "bibtex-tidy" ];
              };
            };
          };

          trouble = {
            enable = true;
            settings.auto_close = true;
          };
        };

      };
    };
}
