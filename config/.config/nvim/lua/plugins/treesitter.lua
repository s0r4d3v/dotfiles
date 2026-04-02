return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      -- Register community grammar for mcfunction (not in official parser list).
      -- nvim-treesitter v1 may not expose get_parser_configs; guard with pcall.
      local ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if ok and type(parsers.get_parser_configs) == "function" then
        parsers.get_parser_configs().mcfunction = {
          install_info = {
            url    = "https://github.com/misode/tree-sitter-mcfunction",
            files  = { "src/parser.c" },
            branch = "master",
          },
          filetype = "mcfunction",
        }
      end

      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "python", "bash", "go", "typescript", "javascript",
          "json", "yaml", "toml", "markdown", "markdown_inline",
          "html", "css", "nix", "vue",
          -- mcfunction: install manually with :TSInstall mcfunction (community parser)
        },
        highlight = { enable = true },
        indent    = { enable = true },
        textobjects = {
          select = {
            enable    = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ib"] = { query = "@code_cell.inner", desc = "in code block" },
              ["ab"] = { query = "@code_cell.outer", desc = "around code block" },
            },
          },
          move = {
            enable = true,
            set_jumps = false,
            goto_next_start     = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sbl"] = "@code_cell.outer",
            },
            swap_previous = {
              ["<leader>sbh"] = "@code_cell.outer",
            },
          },
        },
      })
    end,
  },
  {
    -- Auto-close and rename HTML / Vue / JSX / TSX tags on edit
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
