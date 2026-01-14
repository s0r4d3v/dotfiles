{ ... }:
{
  # Neovim Core: Enable, globals, opts, clipboard
  flake.modules.homeManager.neovim-base =
    { pkgs, ... }:
    {
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
          softtabstop = -1;
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
      };
    };

  # Neovim keymaps (imported by neovim.nix)
  flake.modules.homeManager.neovim-keymaps = {
    programs.nixvim.keymaps = [
      # ─────────────────────────────────────────────────────────────────────
      # Basic
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>W";
        action = "<cmd>wa<cr>";
        options.desc = "Save All";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<cr>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = "<cmd>qa!<cr>";
        options.desc = "Force Quit All";
      }
      {
        mode = "i";
        key = "jj";
        action = "<Esc>:nohl<Cr>";
        options.desc = "Exit Insert and Clear Highlight";
      }
      {
        mode = [
          "n"
          "i"
          "v"
          "o"
          "c"
          "t"
        ];
        key = "<Esc>";
        action = "<Esc>:nohl<Cr>";
        options = {
          silent = true;
          desc = "Clear Highlight";
        };
      }

      # ─────────────────────────────────────────────────────────────────────
      # Windows
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Window Left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Window Down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Window Up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Window Right";
      }
      {
        mode = "n";
        key = "<leader>sv";
        action = "<cmd>vsplit<cr>";
        options.desc = "Split Vertical";
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = "<cmd>split<cr>";
        options.desc = "Split Horizontal";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Buffers
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>lua MiniBufremove.delete()<cr>";
        options.desc = "Delete Buffer";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Editing
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<cr>gv=gv";
        options.desc = "Move Down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<cr>gv=gv";
        options.desc = "Move Up";
      }
      {
        mode = "n";
        key = "x";
        action = "\"_x";
        options.desc = "Delete char (blackhole)";
      }
      {
        mode = "v";
        key = "x";
        action = "\"_x";
        options.desc = "Delete selection (blackhole)";
      }

      # ─────────────────────────────────────────────────────────────────────
      # LSP
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        options.desc = "References";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "Hover";
      }
      {
        mode = "n";
        key = "<leader>la";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "Code Action";
      }
      {
        mode = "n";
        key = "<leader>ln";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        options.desc = "Rename";
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = "<cmd>lua require('conform').format()<cr>";
        options.desc = "Format";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Trouble (x = diagnostics)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>xs";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options.desc = "Symbols";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Find (f = find)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua Snacks.picker.files()<cr>";
        options.desc = "Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        options.desc = "Grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>lua Snacks.picker.help()<cr>";
        options.desc = "Help";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>lua Snacks.picker.recent()<cr>";
        options.desc = "Recent";
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>lua Snacks.picker.lines()<cr>";
        options.desc = "Search Buffer";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Git (g = git)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>lua Snacks.lazygit()<cr>";
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>lua Snacks.git.blame_line()<cr>";
        options.desc = "Blame";
      }
      {
        mode = "n";
        key = "<leader>gB";
        action = "<cmd>lua Snacks.gitbrowse()<cr>";
        options.desc = "Browse";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Terminal (t = terminal)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>lua Snacks.terminal()<cr>";
        options.desc = "Terminal";
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit Terminal";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Flash (motion)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "s";
        action = "<cmd>lua require('flash').jump()<cr>";
        options.desc = "Flash";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<cr>";
        options.desc = "Flash Treesitter";
      }

      # ─────────────────────────────────────────────────────────────────────
      # File explorer
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "\\";
        action = "<cmd>Oil<cr>";
        options.desc = "Oil";
      }
    ];
  };

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
            sources.default = [
              "lsp"
              "path"
              "buffer"
            ];
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
          autoCmd = {
            event = [
              "BufWritePost"
              "BufEnter"
            ];
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

  # UI: Colorscheme, Statusline, Snacks
  flake.modules.homeManager.neovim-plugins = {
    programs.nixvim = {
      colorschemes.dracula = {
        enable = true;
      };

      plugins.web-devicons = {
        enable = true;
      };

      plugins.bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            separator_style = "slant";
            diagnostics = "nvim_lsp";
            offsets = [
              {
                filetype = "neo-tree";
                text = "Neo-tree";
                highlight = "Directory";
                text_align = "left";
              }
            ];
          };
        };
      };

      plugins.lualine = {
        enable = true;
        settings.options = {
          theme = "auto";
          globalstatus = true;
          component_separators = {
            left = "│";
            right = "│";
          };
          section_separators = {
            left = "";
            right = "";
          };
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
          surround = { };
          pairs = { };
          comment = { };
          bufremove = { };
          splitjoin = { };
          move = { };
          ai = { };
        };
      };

      plugins.snacks = {
        enable = true;
        settings = {
          notifier.enabled = true;
          statuscolumn.enabled = true;
          indent.enabled = true;
          scroll.enabled = true;
          bigfile.enabled = true;
          quickfile.enabled = true;
          words.enabled = true;
          picker.enabled = true;
          lazygit.enabled = true;
          terminal.enabled = true;
          git.enabled = true;
        };
      };

      plugins.treesitter = {
        enable = true;
        highlight.enable = true;
        settings.ensure_installed = [
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
          "quarto"
        ];
      };

      plugins.flash = {
        enable = true;
        settings.modes.search.enabled = true;
      };

      plugins.oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          columns = [
            "icon"
            "permissions"
            "size"
            "mtime"
          ];
          keymaps = {
            "\\" = "actions.close";
          };
          skip_confirm_for_simple_edits = true;
          view_options = {
            show_hidden = true;
          };
        };
      };

      plugins.bullets = {
        enable = true;
        settings = {
          bullets_enabled_file_types = [
            "markdown"
            "text"
            "gitcommit"
            "scratch"
            "quarto"
          ];
        };
      };

      plugins.quarto-nvim = {
        enable = true;
      };

      plugins.which-key = {
        enable = true;
        settings.delay = 200;
      };

      plugins.gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
          };
          current_line_blame = true;
          current_line_blame_opts.delay = 500;
        };
      };
    };
  };
}
