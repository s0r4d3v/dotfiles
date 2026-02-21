{ ... }:
{
  flake.modules.homeManager.nixvim =
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
        };

        autoCmd = [
          {
            event = "FileType";
            pattern = "nix,lua,javascript,typescript,vue,markdown,quarto,html,css,yaml,json";
            command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2";
          }
          {
            event = "TextYankPost";
            pattern = "*";
            command = "silent! lua vim.highlight.on_yank()";
          }
        ];

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

        keymaps = [
          # File & Buffer commands
          {
            key = "<leader>w";
            action = ":w<CR>";
            mode = ["n"];
            options.desc = "Write file";
          }
          {
            key = "<leader>W";
            action = ":wa<CR>";
            mode = ["n"];
            options.desc = "Write all files";
          }
          {
            key = "<leader>q";
            action = ":q<CR>";
            mode = ["n"];
            options.desc = "Quit";
          }
          {
            key = "<leader>Q";
            action = ":qa<CR>";
            mode = ["n"];
            options.desc = "Quit all";
          }

          # Window split (horizontal/vertical)
          {
            key = "<leader>v";
            action = ":vsplit<CR>";
            mode = ["n"];
            options.desc = "Split window right";
          }
          {
            key = "<leader>s";
            action = ":split<CR>";
            mode = ["n"];
            options.desc = "Split window down";
          }

          # Ctrl - window navigation
          {
            key = "<C-h>";
            action = "<C-w>h";
            mode = ["n"];
            options.desc = "Move to left window";
          }
          {
            key = "<C-j>";
            action = "<C-w>j";
            mode = ["n"];
            options.desc = "Move to bottom window";
          }
          {
            key = "<C-k>";
            action = "<C-w>k";
            mode = ["n"];
            options.desc = "Move to top window";
          }
          {
            key = "<C-l>";
            action = "<C-w>l";
            mode = ["n"];
            options.desc = "Move to right window";
          }

          # Snacks keybindings
          {
            key = "<leader>e";
            action = "<cmd>lua Snacks.explorer()<CR>";
            mode = ["n"];
            options.desc = "Explorer";
          }
          {
            key = "<leader>ff";
            action = "<cmd>lua Snacks.picker.files()<CR>";
            mode = ["n"];
            options.desc = "Find Files";
          }
          {
            key = "<leader>fg";
            action = "<cmd>lua Snacks.picker.grep()<CR>";
            mode = ["n"];
            options.desc = "Grep";
          }
          {
            key = "<leader>fb";
            action = "<cmd>lua Snacks.picker.buffers()<CR>";
            mode = ["n"];
            options.desc = "Buffers";
          }
          {
            key = "<leader>fh";
            action = "<cmd>lua Snacks.picker.help()<CR>";
            mode = ["n"];
            options.desc = "Help";
          }
          {
            key = "<leader>bd";
            action = "<cmd>lua Snacks.bufdelete()<CR>";
            mode = ["n"];
            options.desc = "Delete Buffer";
          }
          {
            key = "<leader>bD";
            action = "<cmd>lua Snacks.bufdelete.all()<CR>";
            mode = ["n"];
            options.desc = "Delete All Buffers";
          }
          {
            key = "<leader>bo";
            action = "<cmd>lua Snacks.bufdelete.other()<CR>";
            mode = ["n"];
            options.desc = "Delete Other Buffers";
          }
          {
            key = "<leader>gg";
            action = "<cmd>lua Snacks.lazygit()<CR>";
            mode = ["n"];
            options.desc = "Lazygit";
          }
          {
            key = "<leader>gl";
            action = "<cmd>lua Snacks.lazygit.log()<CR>";
            mode = ["n"];
            options.desc = "Lazygit Log";
          }
          {
            key = "<leader>gf";
            action = "<cmd>lua Snacks.lazygit.log_file()<CR>";
            mode = ["n"];
            options.desc = "Lazygit File History";
          }
          {
            key = "<leader>gi";
            action = "<cmd>lua Snacks.picker.gh_issue()<CR>";
            mode = ["n"];
            options.desc = "GitHub Issues";
          }
          {
            key = "<leader>gI";
            action = "<cmd>lua Snacks.picker.gh_issue({ state = 'all' })<CR>";
            mode = ["n"];
            options.desc = "GitHub Issues (all)";
          }
          {
            key = "<leader>gp";
            action = "<cmd>lua Snacks.picker.gh_pr()<CR>";
            mode = ["n"];
            options.desc = "GitHub PRs";
          }
          {
            key = "<leader>gP";
            action = "<cmd>lua Snacks.picker.gh_pr({ state = 'all' })<CR>";
            mode = ["n"];
            options.desc = "GitHub PRs (all)";
          }
          {
            key = "<leader>gb";
            action = "<cmd>lua Snacks.git.blame_line()<CR>";
            mode = ["n"];
            options.desc = "Git Blame Line";
          }
          {
            key = "<leader>gB";
            action = "<cmd>lua Snacks.gitbrowse()<CR>";
            mode = ["n"];
            options.desc = "Git Browse";
          }
          {
            key = "<leader>gB";
            action = "<cmd>lua Snacks.gitbrowse({ what = 'permalink' })<CR>";
            mode = ["v"];
            options.desc = "Git Browse (permalink)";
          }
          {
            key = "]]";
            action = "<cmd>lua Snacks.words.jump(1)<CR>";
            mode = ["n"];
            options.desc = "Next Reference";
          }
          {
            key = "[[";
            action = "<cmd>lua Snacks.words.jump(-1)<CR>";
            mode = ["n"];
            options.desc = "Prev Reference";
          }
          {
            key = "<C-/>";
            action = "<cmd>lua Snacks.terminal.toggle()<CR>";
            mode = ["n" "t"];
            options.desc = "Toggle Float Terminal";
          }
        ];

        plugins = {
          treesitter = {
            enable = true;
            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
              lua
              nix
              python
              vim
              vimdoc
              bash
              json
              yaml
              toml
              markdown
              markdown_inline
            ];
          };

          lsp = {
            enable = true;
            servers = {
              # Lua
              lua_ls.enable = true;
              # Nix
              nixd.enable = true;
              # Python
              pyright.enable = true;
              ruff.enable = true;
              # Markdown (also covers Marp files)
              marksman.enable = true;
              # YAML
              yamlls.enable = true;
              # TOML
              taplo.enable = true;
              # JSON
              jsonls.enable = true;
              # Shell (Bash/Zsh)
              bashls.enable = true;
              # mcfunction (Minecraft datapack)
              spyglassmc_language_server = {
                enable = true;
                package = null;
              };
            };
          };

          cmp = {
            enable = true;
            autoEnableSources = true;
          };

          lsp-format = {
            enable = true;
          };

          which-key = {
            enable = true;
            settings.spec = [
              { __unkeyed-1 = "<leader>f"; group = "Find"; }
              { __unkeyed-1 = "<leader>g"; group = "Git"; icon = " "; }
              { __unkeyed-1 = "<leader>b"; group = "Buffer"; }
            ];
          };

          bufferline = {
            enable = true;
          };

          nvim-autopairs = {
            enable = true;
          };

          snacks = {
            enable = true;
            settings = {
              bigfile.enabled = true;
              bufdelete.enabled = true;
              dashboard = {
                enabled = true;
                sections = [
                  {
                    section = "terminal";
                    cmd = "pokemon-colorscripts --random --no-title";
                    indent = 4;
                    height = 20;
                  }
                  { section = "keys"; gap = 1; padding = 1; }
                  {
                    pane = 2;
                    icon = " ";
                    desc = "Browse Repo";
                    padding = 1;
                    key = "b";
                    action = {
                      __raw = ''
                        function()
                          Snacks.gitbrowse()
                        end
                      '';
                    };
                  }
                  {
                    __raw = ''
                      function()
                        local in_git = Snacks.git.get_root() ~= nil
                        local cmds = {
                          {
                            title = "Notifications",
                            cmd = "gh notify -s -a -n5",
                            action = function()
                              vim.ui.open("https://github.com/notifications")
                            end,
                            key = "n",
                            icon = " ",
                            height = 5,
                            enabled = true,
                          },
                          {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                              vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 7,
                          },
                          {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "p",
                            action = function()
                              vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 7,
                          },
                          {
                            icon = " ",
                            title = "Git Status",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 10,
                          },
                        }
                        return vim.tbl_map(function(cmd)
                          return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                          }, cmd)
                        end, cmds)
                      end
                    '';
                  }
                ];
              };
              explorer.enabled = true;
              gh.enabled = true;
              git.enabled = true;
              gitbrowse.enabled = true;
              image.enabled = true;
              indent.enabled = true;
              input.enabled = true;
              lazygit = {
                enabled = true;
                configure = true;
                win = {
                  style = "lazygit";
                };
              };
              notifier.enabled = true;
              picker.enabled = true;
              quickfile.enabled = true;
              scope.enabled = true;
              scroll.enabled = true;
              statuscolumn.enabled = true;
              terminal = {
                enabled = true;
                win = {
                  style = "float";
                };
              };
              words.enabled = true;
            };
          };
        };
      };
    };
}
