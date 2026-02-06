{ ... }:
{
  flake.modules.homeManager.neovim-lsp =
    { pkgs, ... }:
    {
      # =========================================
      # Packages
      # =========================================
      home.packages = with pkgs; [
        # CLI tools required by LSP / lint
        markdownlint-cli
        eslint_d
        texlivePackages.chktex
      ];

      programs.nixvim = {
        filetype.extension = {
          qmd = "quarto";
        };

        plugins = {
          # -----------------------------
          # Treesitter
          # -----------------------------
          treesitter = {
            enable = true;
            settings = {
              highlight.enable = true;
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
                "javascript"
                "typescript"
                "vue"
              ];
            };
          };

          # -----------------------------
          # LSP (diagnostics integrated)
          # -----------------------------
          lsp = {
            enable = true;
            servers = {
              pyright.enable = true;
              ruff.enable = true;
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
              html.enable = true;
              cssls.enable = true;

              texlab = {
                enable = true;
                settings.texlab.chktex.onOpenAndSave = true;
              };

              spyglassmc_language_server = {
                enable = true;
                package = null;
              };
            };
          };

          lsp-signature.enable = true;

          # Diagnostics
          trouble.enable = true;

          # -----------------------------
          # Lint (For only langs that LSP doesn't have lint function)
          # -----------------------------
          lint = {
            enable = true;
            lintersByFt = {
              markdown = [ "markdownlint" ];
              quarto = [ "markdownlint" ];
              javascript = [ "eslint_d" ];
              typescript = [ "eslint_d" ];
              vue = [ "eslint_d" ];
            };
            autoCmd.event = [
              "BufWritePost"
              "BufEnter"
            ];
          };

          # -----------------------------
          # Completion
          # -----------------------------
          cmp = {
            enable = true;
            autoEnableSources = true;
            settings = {
              snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
              sources = [
                { name = "nvim_lsp"; }
                { name = "path"; }
                { name = "luasnip"; }
                { name = "nvim_lsp_signature_help"; }
              ];
            };
          };

          luasnip.enable = true;
          friendly-snippets.enable = true;
          cmp-nvim-lsp-signature-help.enable = true;
          lspkind.enable = true;

          # -----------------------------
          # UI / Formatting
          # -----------------------------
          lsp-format.enable = true;
        };
      };
    };
}
