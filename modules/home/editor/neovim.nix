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
          number = true;
          relativenumber = true;
          signcolumn = "yes";
          mouse = "";
          termguicolors = true;
          updatetime = 200;
          timeoutlen = 400;
        };
        keymaps = [
          {
            key = "<leader>e";
            action = "<cmd>lua Snacks.explorer()<CR>";
            options.desc = "Explorer";
          }
          {
            key = "<leader>ff";
            action = "<cmd>lua Snacks.picker.files()<CR>";
            options.desc = "Find Files";
          }
          {
            key = "<leader>fg";
            action = "<cmd>lua Snacks.picker.grep()<CR>";
            options.desc = "Grep";
          }
          {
            key = "<leader>fb";
            action = "<cmd>lua Snacks.picker.buffers()<CR>";
            options.desc = "Buffers";
          }
          {
            key = "<leader>fh";
            action = "<cmd>lua Snacks.picker.help()<CR>";
            options.desc = "Help";
          }
        ];
        plugins = {
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
          lsp-format.enable = true;
          which-key = {
            enable = true;
            settings.spec = [
              { __unkeyed-1 = "<leader>f"; group = "Find"; }
            ];
          };
          snacks = {
            enable = true;
            settings = {
              explorer.enabled = true;
              input.enabled = true;
              notifier.enabled = true;
              picker.enabled = true;
            };
          };
        };
      };
    };
}
