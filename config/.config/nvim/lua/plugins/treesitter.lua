return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      -- nvim-treesitter (main branch) only accepts install_dir in setup().
      -- Neovim 0.11+ enables treesitter highlight/indent by default.
      -- Parsers are installed via :TSInstall (ensure_installed is gone).
      require("nvim-treesitter").setup({})

      -- -- textobjects: config --
      local ts_to = require("nvim-treesitter-textobjects")
      ts_to.setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = false,
        },
      })

      -- -- textobjects: select keymaps --
      local select = require("nvim-treesitter-textobjects.select")
      local sel = function(capture, desc)
        return function() select.select_textobject(capture, "textobjects") end
      end
      vim.keymap.set({ "x", "o" }, "af", sel("@function.outer"), { desc = "around function" })
      vim.keymap.set({ "x", "o" }, "if", sel("@function.inner"), { desc = "in function" })
      vim.keymap.set({ "x", "o" }, "ac", sel("@class.outer"),    { desc = "around class" })
      vim.keymap.set({ "x", "o" }, "ic", sel("@class.inner"),    { desc = "in class" })
      vim.keymap.set({ "x", "o" }, "ab", sel("@code_cell.outer"), { desc = "around code block" })
      vim.keymap.set({ "x", "o" }, "ib", sel("@code_cell.inner"), { desc = "in code block" })

      -- -- textobjects: move keymaps --
      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer") end,     { desc = "Next function" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer") end, { desc = "Prev function" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer") end,        { desc = "Next class" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer") end,    { desc = "Prev class" })
      vim.keymap.set({ "n", "x", "o" }, "]b", function() move.goto_next_start("@code_cell.inner") end,    { desc = "Next code block" })
      vim.keymap.set({ "n", "x", "o" }, "[b", function() move.goto_previous_start("@code_cell.inner") end, { desc = "Prev code block" })

      -- -- textobjects: swap keymaps --
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>sbl", function() swap.swap_next("@code_cell.outer") end,     { desc = "Swap code block down" })
      vim.keymap.set("n", "<leader>sbh", function() swap.swap_previous("@code_cell.outer") end, { desc = "Swap code block up" })
    end,
  },
  {
    -- Auto-close and rename HTML / Vue / JSX / TSX tags on edit
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
