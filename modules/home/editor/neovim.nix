{ ... }:
{
  flake.modules.homeManager.nixvim =
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
        enable = true;

        defaultEditor = true;

        colorscheme = "";

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
          shiftwidth = 4;
          tabstop = 4;
          softtabstop = 4;
          autoindent = true;
          smartindent = true;

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

        plugins = {
          snacks = {
            enable = true;
            settings = {
              bigfile.enabled = true;
              explorer.enabled = true;
              image.enabled = true;
              input.enabled = true;
              notifier.enabled = true;
              picker.enabled = true;
              quickfile.enabled = true;
              scope.enabled = true;
              scroll.enabled = true;
              statuscolumn.enabled = true;
              words.enabled = true;
            };
          };
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
                "dockerfile"
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
              dockerls.enable = true;

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
