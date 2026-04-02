-- Jupyter notebook support
-- Stack: jupytext.nvim (ipynb ↔ markdown) + molten-nvim (run cells, show output)
--        + quarto-nvim/otter.nvim (LSP in cells) + image.nvim (inline plots)
return {
  -- jupytext: transparently convert .ipynb to markdown on open, back on save
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- must load before opening .ipynb files
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },

  -- image.nvim: render images inline in the terminal (kitty graphics protocol)
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      processor = "magick_cli",
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "popup",
        },
      },
      max_height_window_percentage = 40,
      tmux_show_only_in_active_window = true,
      window_overlap_clear_enabled = true,
    },
  },

  -- molten-nvim: run code against Jupyter kernels, show output inline
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true -- markdown: covered line is just ```
      vim.g.molten_wrap_output = true
    end,
    keys = {
      { "<localleader>mi", "<cmd>MoltenInit<cr>",              desc = "Molten init kernel" },
      { "<localleader>ml", "<cmd>MoltenEvaluateLine<cr>",      desc = "Molten run line" },
      { "<localleader>mr", "<cmd>MoltenReevaluateCell<cr>",    desc = "Molten re-run cell" },
      { "<localleader>mv", ":<C-u>MoltenEvaluateVisual<cr>",   desc = "Molten run selection", mode = "v" },
      { "<localleader>md", "<cmd>MoltenDelete<cr>",            desc = "Molten delete cell" },
      { "<localleader>mo", "<cmd>MoltenShowOutput<cr>",        desc = "Molten show output" },
      { "<localleader>mh", "<cmd>MoltenHideOutput<cr>",        desc = "Molten hide output" },
      { "<localleader>mI", "<cmd>MoltenImportOutput<cr>",      desc = "Molten import output" },
      { "<localleader>mE", "<cmd>MoltenExportOutput<cr>",      desc = "Molten export output" },
    },
  },

  -- otter.nvim: LSP features inside embedded code blocks
  {
    "jmbuhr/otter.nvim",
    lazy = true,
  },

  -- quarto-nvim: orchestrates otter + code runner for markdown notebooks
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "all", -- detect both ```python and ```{python} code blocks
        languages = { "python", "r", "julia", "bash", "lua" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    config = function(_, opts)
      local quarto = require("quarto")
      quarto.setup(opts)

      -- Auto-activate quarto for markdown buffers (enables runner + LSP in cells)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "quarto" },
        callback = function()
          vim.schedule(function()
            quarto.activate()
          end)
        end,
      })
    end,
    keys = {
      { "<localleader>rc", function() require("quarto.runner").run_cell() end,       desc = "Run cell" },
      { "<localleader>ra", function() require("quarto.runner").run_above() end,      desc = "Run cell and above" },
      { "<localleader>rA", function() require("quarto.runner").run_all() end,        desc = "Run all cells" },
      { "<localleader>rl", function() require("quarto.runner").run_line() end,       desc = "Run line" },
      { "<localleader>r",  function() require("quarto.runner").run_range() end,      desc = "Run selection", mode = "v" },
    },
  },
}
