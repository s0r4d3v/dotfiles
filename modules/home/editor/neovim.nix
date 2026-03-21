{ ... }:
{
  flake.modules.homeManager.nixvim =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        quarto
        nodejs
        shellcheck
        htmlhint
        stylelint
      ];

      home.sessionPath = [ "$HOME/.npm-global/bin" ];

      home.activation.installNpmLanguageServers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export npm_config_prefix="$HOME/.npm-global"
        if ! [ -f "$HOME/.npm-global/bin/spyglassmc-language-server" ]; then
          echo "Installing @spyglassmc/language-server..."
          ${pkgs.nodejs}/bin/npm install -g @spyglassmc/language-server
        fi
        if ! [ -f "$HOME/.npm-global/bin/unocss-language-server" ]; then
          echo "Installing @unocss/language-server..."
          ${pkgs.nodejs}/bin/npm install -g unocss-language-server
        fi
      '';

      programs.nixvim = {
        enable = true;
        defaultEditor = true;

        colorschemes = {
          catppuccin = {
            enable = true;
            settings = {
              flavour = "macchiato";
              term_colors = true;
            };
          };
        };

        globals = {
          mapleader = " ";
          maplocalleader = " ";

          molten_auto_open_output = false;
          molten_image_provider = "none";
          molten_wrap_output = true;
          molten_virt_text_output = true;
          molten_virt_lines_off_by_1 = true;
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

          list = true;
          listchars = {
            tab = "→ ";
            trail = "·";
            nbsp = "␣";
          };

          colorcolumn = "80,120";
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
          {
            event = [
              "BufWritePost"
              "BufReadPost"
              "InsertLeave"
              "LspAttach"
            ];
            pattern = "*";
            command = "lua require('lint').try_lint()";
          }
        ];

        # Clipboard (with SSH/OSC52 support)
        clipboard.register = "unnamedplus";

        keymaps = [
          # Window split
          {
            key = "<C-w>-";
            action = ":split<CR>";
            mode = [ "n" ];
            options.desc = "Split window horizontally";
          }
          {
            key = "<C-w>\\";
            action = ":vsplit<CR>";
            mode = [ "n" ];
            options.desc = "Split window vertically";
          }

          # File & Buffer commands
          {
            key = "<leader>w";
            action = ":w<CR>";
            mode = [ "n" ];
            options.desc = "Write file";
          }
          {
            key = "<leader>W";
            action = ":wa<CR>";
            mode = [ "n" ];
            options.desc = "Write all files";
          }
          {
            key = "<leader>q";
            action = ":q<CR>";
            mode = [ "n" ];
            options.desc = "Quit";
          }
          {
            key = "<leader>Q";
            action = ":qa<CR>";
            mode = [ "n" ];
            options.desc = "Quit all";
          }

          # Clear search highlight
          {
            key = "<leader>h";
            action = "<cmd>nohlsearch<CR>";
            mode = [ "n" ];
            options.desc = "Clear search highlight";
          }

          # Snacks keybindings
          {
            key = "<leader>e";
            action = "<cmd>Yazi<CR>";
            mode = [ "n" ];
            options.desc = "Yazi Explorer";
          }
          {
            key = "<leader>ff";
            action = "<cmd>lua Snacks.picker.files()<CR>";
            mode = [ "n" ];
            options.desc = "Find Files";
          }
          {
            key = "<leader>fg";
            action = "<cmd>lua Snacks.picker.grep()<CR>";
            mode = [ "n" ];
            options.desc = "Grep";
          }
          {
            key = "<leader>fb";
            action = "<cmd>lua Snacks.picker.buffers()<CR>";
            mode = [ "n" ];
            options.desc = "Buffers";
          }
          {
            key = "<leader>fh";
            action = "<cmd>lua Snacks.picker.help()<CR>";
            mode = [ "n" ];
            options.desc = "Help";
          }
          {
            key = "<leader>bd";
            action = "<cmd>lua Snacks.bufdelete()<CR>";
            mode = [ "n" ];
            options.desc = "Delete Buffer";
          }
          {
            key = "<leader>bD";
            action = "<cmd>lua Snacks.bufdelete.all()<CR>";
            mode = [ "n" ];
            options.desc = "Delete All Buffers";
          }
          {
            key = "<leader>bo";
            action = "<cmd>lua Snacks.bufdelete.other()<CR>";
            mode = [ "n" ];
            options.desc = "Delete Other Buffers";
          }
          {
            key = "<leader>gg";
            action = "<cmd>lua Snacks.lazygit()<CR>";
            mode = [ "n" ];
            options.desc = "Lazygit";
          }
          {
            key = "<leader>gl";
            action = "<cmd>lua Snacks.lazygit.log()<CR>";
            mode = [ "n" ];
            options.desc = "Lazygit Log";
          }
          {
            key = "<leader>gf";
            action = "<cmd>lua Snacks.lazygit.log_file()<CR>";
            mode = [ "n" ];
            options.desc = "Lazygit File History";
          }
          {
            key = "<leader>gi";
            action = "<cmd>lua Snacks.picker.gh_issue()<CR>";
            mode = [ "n" ];
            options.desc = "GitHub Issues";
          }
          {
            key = "<leader>gI";
            action = "<cmd>lua Snacks.picker.gh_issue({ state = 'all' })<CR>";
            mode = [ "n" ];
            options.desc = "GitHub Issues (all)";
          }
          {
            key = "<leader>gp";
            action = "<cmd>lua Snacks.picker.gh_pr()<CR>";
            mode = [ "n" ];
            options.desc = "GitHub PRs";
          }
          {
            key = "<leader>gP";
            action = "<cmd>lua Snacks.picker.gh_pr({ state = 'all' })<CR>";
            mode = [ "n" ];
            options.desc = "GitHub PRs (all)";
          }
          {
            key = "<leader>gb";
            action = "<cmd>lua Snacks.git.blame_line()<CR>";
            mode = [ "n" ];
            options.desc = "Git Blame Line";
          }
          {
            key = "<leader>gB";
            action = "<cmd>lua Snacks.gitbrowse()<CR>";
            mode = [ "n" ];
            options.desc = "Git Browse";
          }
          {
            key = "<leader>gB";
            action = "<cmd>lua Snacks.gitbrowse({ what = 'permalink' })<CR>";
            mode = [ "v" ];
            options.desc = "Git Browse (permalink)";
          }
          {
            key = "<leader>xx";
            action = "<cmd>Trouble diagnostics toggle<CR>";
            mode = [ "n" ];
            options.desc = "Diagnostics";
          }
          {
            key = "<leader>xb";
            action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
            mode = [ "n" ];
            options.desc = "Buffer Diagnostics";
          }
          {
            key = "]]";
            action = "<cmd>lua Snacks.words.jump(1)<CR>";
            mode = [ "n" ];
            options.desc = "Next Reference";
          }
          {
            key = "[[";
            action = "<cmd>lua Snacks.words.jump(-1)<CR>";
            mode = [ "n" ];
            options.desc = "Prev Reference";
          }

          # Molten
          {
            key = "<leader>me";
            action = ":MoltenEvaluateOperator<CR>";
            mode = [ "n" ];
            options.desc = "Evaluate operator";
          }
          {
            key = "<leader>mos";
            action = ":noautocmd MoltenEnterOutput<CR>";
            mode = [ "n" ];
            options.desc = "Show output window";
          }
          {
            key = "<leader>mrr";
            action = ":MoltenReevaluateCell<CR>";
            mode = [ "n" ];
            options.desc = "Re-eval cell";
          }
          {
            key = "<leader>mr";
            action = ":<C-u>MoltenEvaluateVisual<CR>gv";
            mode = [ "v" ];
            options.desc = "Execute visual selection";
          }
          {
            key = "<leader>moh";
            action = ":MoltenHideOutput<CR>";
            mode = [ "n" ];
            options.desc = "Hide output window";
          }
          {
            key = "<leader>md";
            action = ":MoltenDelete<CR>";
            mode = [ "n" ];
            options.desc = "Delete Molten cell";
          }
          {
            key = "<leader>mx";
            action = ":MoltenOpenInBrowser<CR>";
            mode = [ "n" ];
            options.desc = "Open output in browser";
          }
          {
            key = "<leader>mc";
            action.__raw = ''
              function()
                local row = vim.api.nvim_win_get_cursor(0)[1]
                vim.api.nvim_buf_set_lines(0, row, row, false, {
                  "",
                  "```{python}",
                  "",
                  "```",
                  "",
                })
                vim.api.nvim_win_set_cursor(0, { row + 3, 0 })
                vim.cmd("startinsert")
              end
            '';
            mode = [ "n" ];
            options.desc = "New code cell below";
          }

          # Quarto runner for notebook cells
          {
            key = "<localleader>rc";
            action.__raw = "require('quarto.runner').run_cell";
            mode = [ "n" ];
            options.desc = "Run Quarto/Jupyter cell";
          }
          {
            key = "<localleader>ra";
            action.__raw = "require('quarto.runner').run_above";
            mode = [ "n" ];
            options.desc = "Run cell and above";
          }
          {
            key = "<localleader>rA";
            action.__raw = "require('quarto.runner').run_all";
            mode = [ "n" ];
            options.desc = "Run all notebook cells";
          }
          {
            key = "<localleader>rl";
            action.__raw = "require('quarto.runner').run_line";
            mode = [ "n" ];
            options.desc = "Run Jupyter cell line";
          }
          {
            key = "<localleader>r";
            action.__raw = "require('quarto.runner').run_range";
            mode = [ "v" ];
            options.desc = "Run visual notebook cell selection";
          }
          {
            key = "<localleader>RA";
            action.__raw = "function() require('quarto.runner').run_all(true) end";
            mode = [ "n" ];
            options.desc = "Run all notebook cells (all languages)";
          }
        ];

        filetype = {
          extension = {
            mcfunction = "mcfunction";
          };
        };

        extraPlugins = [ ];

        diagnostic = {
          settings = {
            virtual_lines = {
              current_line = true;
            };
            virtual_text = false;
            signs = true;
            severity_sort = true;
          };
        };

        plugins = {
          treesitter = {
            enable = true;
            settings = {
              highlight = {
                enable = true;
              };
            };
            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
              lua
              nix
              python
              # vim
              (pkgs.tree-sitter.buildGrammar {
                language = "vim";
                version = "main";
                src = pkgs.fetchFromGitHub {
                  owner = "tree-sitter-grammars";
                  repo = "tree-sitter-vim";
                  rev = "main";
                  hash = "sha256-MnLBFuJCJbetcS07fG5fkCwHtf/EcNP+Syf0Gn0K39c=";
                };
              })
              vimdoc
              bash
              json
              yaml
              toml
              markdown
              markdown_inline
              javascript
              typescript
              css
              html
              vue
              regex
              comment
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
              # HTML
              html.enable = true;
              # HTMX
              htmx.enable = true;
              # CSS
              cssls.enable = true;
              # UnoCSS
              unocss = {
                enable = true;
                package = null;
              };
              # Vue
              # ts_ls.enable = true;
              # vtsls.enable = true;
              # vue_ls.enable = true;
              # YAML
              yamlls.enable = true;
              # TOML
              taplo.enable = true;
              # JSON
              jsonls.enable = true;
              # Shell (Bash/Zsh)
              bashls.enable = true;
              # Docker
              dockerls.enable = true;
              docker_compose_language_service.enable = true;
              # Terraform
              terraformls.enable = true;
              # Helm (Kubernetes)
              helm_ls.enable = true;
              # mcfunction (Minecraft datapack)
              spyglassmc_language_server = {
                enable = true;
                package = null;
              };
            };
          };

          conform-nvim = {
            enable = true;
            autoInstall.enable = true;
            settings = {
              format_on_save = {
                timeout_ms = 3000;
                lsp_format = "fallback";
              };
              format_after_save.__raw = ''
                function(bufnr)
                  local ft = vim.bo[bufnr].filetype
                  if ft == "quarto" or ft == "markdown" then
                    return { lsp_format = "fallback" }
                  end
                end
              '';
              formatters_by_ft = {
                nix = [ "nixfmt" ];
                python = [
                  "ruff_format"
                  "ruff_fix"
                ];
                lua = [ "stylua" ];
                javascript = [ "prettier" ];
                typescript = [ "prettier" ];
                html = [ "prettier" ];
                css = [ "prettier" ];
                json = [ "prettier" ];
                yaml = [ "prettier" ];
                markdown = [
                  "prettier"
                  "injected"
                ];
                quarto = [
                  "prettier"
                  "injected"
                ];
                bash = [ "shfmt" ];
              };
              formatters = {
                prettier = {
                  options = {
                    ext_parsers = {
                      ipynb = "markdown";
                    };
                  };
                };
              };
            };
          };

          lint = {
            enable = true;
            lintersByFt = {
              python = [ "ruff" ];
              bash = [ "shellcheck" ];
              nix = [ "nix" ];
              html = [ "htmlhint" ];
              css = [ "stylelint" ];
            };
          };

          treesitter-context = {
            enable = true;
          };

          treesitter-textobjects = {
            enable = true;
            settings = {
              select = {
                enable = true;
                lookahead = true;
                keymaps = {
                  "af" = "@function.outer";
                  "if" = "@function.inner";
                  "ac" = "@class.outer";
                  "ic" = "@class.inner";
                  "ib" = {
                    query = "@code_cell.inner";
                    desc = "in block";
                  };
                  "ab" = {
                    query = "@code_cell.outer";
                    desc = "around block";
                  };
                };
              };
              move = {
                enable = true;
                set_jumps = false;
                goto_next_start = {
                  "]f" = "@function.outer";
                  "]c" = {
                    query = "@code_cell.inner";
                    desc = "next code block";
                  };
                };
                goto_previous_start = {
                  "[f" = "@function.outer";
                  "[c" = {
                    query = "@code_cell.inner";
                    desc = "previous code block";
                  };
                };
              };
              swap = {
                enable = true;
                swap_next = {
                  "<leader>sbl" = "@code_cell.outer";
                };
                swap_previous = {
                  "<leader>sbh" = "@code_cell.outer";
                };
              };
            };
          };

          blink-cmp = {
            enable = true;
            settings = {
              keymap.preset = "default";
              completion = {
                documentation.auto_show = true;
                documentation.auto_show_delay_ms = 200;
              };
              signature.enabled = true;
              sources = {
                default = [
                  "lsp"
                  "path"
                  "snippets"
                  "buffer"
                  "lazydev"
                ];
                providers = {
                  snippets.opts.friendly_snippets = true;
                  lazydev = {
                    name = "LazyDev";
                    module = "lazydev.integrations.blink";
                    score_offset = 100;
                  };
                };
              };
            };
          };

          friendly-snippets = {
            enable = true;
          };

          trouble = {
            enable = true;
          };

          which-key = {
            enable = true;
            settings.spec = [
              {
                __unkeyed-1 = "<leader>f";
                group = "Find";
              }
              {
                __unkeyed-1 = "<leader>g";
                group = "Git";
                icon = " ";
              }
              {
                __unkeyed-1 = "<leader>b";
                group = "Buffer";
              }
              {
                __unkeyed-1 = "<leader>x";
                group = "Diagnostics";
              }
              {
                __unkeyed-1 = "<leader>m";
                group = "Molten";
              }
              {
                __unkeyed-1 = "<leader>mo";
                group = "Output";
              }
              {
                __unkeyed-1 = "<leader>mr";
                group = "Run";
              }
              {
                __unkeyed-1 = "<leader>sb";
                group = "Swap Block";
              }
              {
                __unkeyed-1 = "<localleader>r";
                group = "Run Cell";
              }
              {
                __unkeyed-1 = "<localleader>R";
                group = "Run All";
              }
            ];
          };

          bufferline = {
            enable = true;
          };

          lualine = {
            enable = true;
            settings.options = {
              theme = "catppuccin";
            };
          };

          nvim-autopairs = {
            enable = true;
          };

          gitsigns = {
            enable = true;
          };

          todo-comments = {
            enable = true;
          };

          lazydev = {
            enable = true;
          };

          render-markdown = {
            enable = true;
          };

          flash = {
            enable = true;
          };

          neotest = {
            enable = true;
          };

          tmux-navigator = {
            enable = true;
          };

          yazi = {
            enable = true;
            settings = {
              enable_mouse_support = false;
            };
          };

          molten = {
            enable = true;
          };

          quarto = {
            enable = true;
            settings = {
              codeRunner = {
                enabled = true;
                default_method = "molten";
                ft_runners = {
                  python = "molten";
                };
                never_run = [ "yaml" ];
              };
            };
          };

          otter = {
            enable = true;
          };

          jupytext = {
            enable = true;
            settings = {
              custom_language_formatting = {
                python = {
                  extension = "qmd";
                  style = "quarto";
                  force_ft = "quarto";
                };
              };
            };
          };

          hydra = {
            enable = true;
          };

          mini = {
            enable = true;
            mockDevIcons = true;
            modules = {
              icons = { };
              surround = { };
            };
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
                  {
                    section = "keys";
                    gap = 1;
                    padding = 1;
                  }
                  {
                    pane = 2;
                    icon = " ";
                    desc = "Browse Repo";
                    padding = 1;
                    key = "B";
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
                        local has_remote = in_git and vim.fn.system("git remote") ~= ""  -- 追加
                        local cmds = {
                          {
                            title = "Notifications",
                            cmd = "gh notify -s -a -n5",
                            action = function()
                              vim.ui.open("https://github.com/notifications")
                            end,
                            key = "N",
                            icon = " ",
                            height = 5,
                            enabled = true,
                          },
                          {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "I",
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
                            key = "P",
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
                            enabled = has_remote,
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
              words.enabled = true;
            };
          };
        };

        extraFiles = {
          "after/queries/markdown/textobjects.scm".text = ''
            ;; extends
            (fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer
          '';
        };

        extraConfigLua = ''
          local orig_notify = vim.notify
          vim.notify = function(msg, ...)
            if msg and msg:match("No explicit query provided") then return end
            orig_notify(msg, ...)
          end

          -- ============================================================
          -- SSH環境のクリップボード設定
          -- lemonade経由でローカルMacのクリップボードを双方向に読み書きする。
          -- lemonadeサーバーはローカルMacのlaunchd agentで常時起動し、
          -- SSH RemoteForward 2489でリモートから透過的にアクセスできる。
          -- lemonadeが未インストールの場合はOSC 52にフォールバック。
          -- ============================================================
          if os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CLIENT") ~= nil then
            if vim.fn.exepath("lemonade") ~= "" then
              vim.g.clipboard = {
                name  = "lemonade",
                copy  = {
                  ["+"] = { "lemonade", "--port", "2489", "copy" },
                  ["*"] = { "lemonade", "--port", "2489", "copy" },
                },
                paste = {
                  ["+"] = { "lemonade", "--port", "2489", "paste" },
                  ["*"] = { "lemonade", "--port", "2489", "paste" },
                },
                cache_enabled = 0,
              }
            else
              vim.g.clipboard = {
                name  = "OSC 52",
                copy  = {
                  ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
                  ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
                },
                paste = {
                  ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
                  ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
                },
              }
            end
          end

          -- Activate Quarto for markdown
          vim.api.nvim_create_autocmd('FileType', {
            pattern = 'markdown',
            callback = function()
              require('quarto').activate()
            end,
          })

          -- Ensure proper code cell textobjects (requires manual capture in after/queries/markdown/textobjects.scm):
          -- ;; extends\n(fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer
          -- This enables ib, ab, ]b, [b etc. for code cell movement/selection/swap.

          -- Automatically import/export output chunks and switch molten output mode (see notebook setup instructions)
          local imb = function(e)
              vim.schedule(function()
                  local kernels = vim.fn.MoltenAvailableKernels()
                  local try_kernel_name = function()
                      local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
                      return metadata.kernelspec.name
                  end
                  local ok, kernel_name = pcall(try_kernel_name)
                  if not ok or not vim.tbl_contains(kernels, kernel_name) then
                      kernel_name = nil
                      local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                      if venv ~= nil then
                          kernel_name = string.match(venv, "/.+/(.+)")
                      end
                  end
                  if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                      vim.cmd(("MoltenInit %s"):format(kernel_name))
                  end
                  vim.cmd("MoltenImportOutput")
              end)
          end
          vim.api.nvim_create_autocmd("BufAdd", { pattern = { "*.ipynb" }, callback = imb })
          vim.api.nvim_create_autocmd("BufEnter", {
            pattern = { "*.ipynb" },
            callback = function(e)
              if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then imb(e) end
            end,
          })
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.ipynb" },
            callback = function()
              if require("molten.status").initialized() == "Molten" then
                vim.cmd("MoltenExportOutput!")
              end
            end,
          })

          vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.py",
            callback = function(e)
              if string.match(e.file, ".otter.") then return end
              if require("molten.status").initialized() == "Molten" then
                vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
                vim.fn.MoltenUpdateOption("virt_text_output", false)
              else
                vim.g.molten_virt_lines_off_by_1 = false
                vim.g.molten_virt_text_output = false
              end
            end,
          })
          vim.api.nvim_create_autocmd("BufEnter", {
            pattern = { "*.qmd", "*.md", "*.ipynb" },
            callback = function(e)
              if string.match(e.file, ".otter.") then return end
              if require("molten.status").initialized() == "Molten" then
                vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
                vim.fn.MoltenUpdateOption("virt_text_output", true)
              else
                vim.g.molten_virt_lines_off_by_1 = true
                vim.g.molten_virt_text_output = true
              end
            end,
          })

          -- New notebook creation user command
          local default_notebook = [[
            {
              "cells": [
               {
                "cell_type": "markdown",
                "metadata": {},
                "source": [ "" ]
               }
              ],
              "metadata": {
               "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3"
               },
               "language_info": {
                "codemirror_mode": { "name": "ipython" },
                "file_extension": ".py",
                "mimetype": "text/x-python",
                "name": "python",
                "nbconvert_exporter": "python",
                "pygments_lexer": "ipython3"
               }
              },
              "nbformat": 4,
              "nbformat_minor": 5
            }
          ]]
          local function new_notebook(filename)
            local path = filename .. ".ipynb"
            local file = io.open(path, "w")
            if file then
              file:write(default_notebook)
              file:close()
              vim.cmd("edit " .. path)
            else
              print("Error: Could not open new notebook file for writing.")
            end
          end
          vim.api.nvim_create_user_command('NewNotebook', function(opts)
            new_notebook(opts.args)
          end, {
            nargs = 1,
            complete = 'file'
          })
        '';
      };
    };
}
