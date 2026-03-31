return {
  -- ===========================================================================
  -- Fuzzy Finder
  -- ===========================================================================
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>",                  desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>",              desc = "Live grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>",                desc = "Buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>",               desc = "Recent files" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>",   desc = "Diagnostics" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- File Explorer
  -- ===========================================================================
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Open file explorer" },
    },
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
    },
  },

  -- ===========================================================================
  -- Tmux / Nvim window navigation  (C-hjkl across both)
  -- ===========================================================================
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup()
      vim.keymap.set({ "n", "t" }, "<C-h>", "<CMD>NavigatorLeft<CR>")
      vim.keymap.set({ "n", "t" }, "<C-j>", "<CMD>NavigatorDown<CR>")
      vim.keymap.set({ "n", "t" }, "<C-k>", "<CMD>NavigatorUp<CR>")
      vim.keymap.set({ "n", "t" }, "<C-l>", "<CMD>NavigatorRight<CR>")
      -- Set @pane-is-vim so tmux (local or remote) forwards C-hjkl to nvim.
      vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
        callback = function() vim.fn.system("tmux set-option -p @pane-is-vim 1") end,
      })
      vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
        callback = function() vim.fn.system("tmux set-option -p @pane-is-vim 0") end,
      })
    end,
  },

  -- ===========================================================================
  -- File bookmarks
  -- ===========================================================================
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>a",  function() harpoon:list():add() end,                         { desc = "Harpoon add" })
      vim.keymap.set("n", "<C-e>",      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      vim.keymap.set("n", "<leader>1",  function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
      vim.keymap.set("n", "<leader>2",  function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
      vim.keymap.set("n", "<leader>3",  function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
      vim.keymap.set("n", "<leader>4",  function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
    end,
  },

  -- ===========================================================================
  -- Symbol outline
  -- ===========================================================================
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Symbol outline" },
    },
    opts = {
      on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr, desc = "Prev symbol" })
        vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr, desc = "Next symbol" })
      end,
    },
  },

  -- ===========================================================================
  -- Jump / motion
  -- ===========================================================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s",     function() require("flash").jump() end,       mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S",     function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash treesitter" },
      { "r",     function() require("flash").remote() end,     mode = "o",               desc = "Flash remote" },
      { "<c-s>", function() require("flash").toggle() end,     mode = "c",               desc = "Toggle flash search" },
    },
  },
}
