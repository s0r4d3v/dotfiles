-- Jupyter notebook support
-- jupytext (ipynb <-> md) + molten (kernel) + quarto/otter (LSP) + image.nvim (plots)
-- Quarto activated via ftplugin/markdown.lua

return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },

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

  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_wrap_output = true
    end,
    keys = {
      { "<localleader>mi", "<cmd>MoltenInit<cr>",                  desc = "Molten init kernel" },
      { "<localleader>e",  "<cmd>MoltenEvaluateOperator<cr>",      desc = "Molten eval operator" },
      { "<localleader>ml", "<cmd>MoltenEvaluateLine<cr>",          desc = "Molten run line" },
      { "<localleader>mr", "<cmd>MoltenReevaluateCell<cr>",        desc = "Molten re-run cell" },
      { "<localleader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv",     desc = "Molten run selection", mode = "v" },
      { "<localleader>md", "<cmd>MoltenDelete<cr>",                desc = "Molten delete cell" },
      { "<localleader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Molten open output" },
      { "<localleader>mh", "<cmd>MoltenHideOutput<cr>",            desc = "Molten hide output" },
    },
    config = function()
      local function init_molten_buffer(e)
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()
          local ok, kernel_name = pcall(function()
            return vim.json.decode(io.open(e.file, "r"):read("a")).metadata.kernelspec.name
          end)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            if venv then
              kernel_name = string.match(venv, "/.+/(.+)")
            end
          end
          if kernel_name and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(("MoltenInit %s"):format(kernel_name))
          end
          vim.cmd("MoltenImportOutput")
        end)
      end

      vim.api.nvim_create_autocmd("BufAdd", {
        pattern = "*.ipynb",
        callback = init_molten_buffer,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.ipynb",
        callback = function(e)
          if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            init_molten_buffer(e)
          end
        end,
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.ipynb",
        callback = function()
          if require("molten.status").initialized() == "Molten" then
            vim.cmd("MoltenExportOutput!")
          end
        end,
      })
    end,
  },

  { "jmbuhr/otter.nvim", lazy = true },

  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown" },
    dependencies = { "jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "all",
        languages = { "python", "r", "julia", "bash", "lua" },
        diagnostics = { enabled = true, triggers = { "BufWritePost" } },
        completion = { enabled = true },
      },
      codeRunner = { enabled = true, default_method = "molten" },
    },
    keys = {
      -- freshen_parser() invalidates the markdown treesitter parser before each
      -- cell run so otter's sync_raft always sees injection children (python etc).
      --
      -- Why: otter's extract_code_chunks calls parser:parse(true) WITHOUT
      -- invalidate().  If _processed_injection_range was set during a prior parse
      -- where the python .so wasn't yet loaded, subsequent parse(true) calls skip
      -- injection re-evaluation (cache thinks it already covered the document).
      -- invalidate(true) clears cached trees + resets _processed_injection_range
      -- so the next parse() re-runs _get_injections() and creates children.
      {
        "<localleader>rc",
        function()
          local ok, p = pcall(vim.treesitter.get_parser, 0, "markdown")
          if ok then p:invalidate(true) end
          require("quarto.runner").run_cell()
        end,
        desc = "Run cell",
      },
      {
        "<localleader>ra",
        function()
          local ok, p = pcall(vim.treesitter.get_parser, 0, "markdown")
          if ok then p:invalidate(true) end
          require("quarto.runner").run_above()
        end,
        desc = "Run cell and above",
      },
      {
        "<localleader>rA",
        function()
          local ok, p = pcall(vim.treesitter.get_parser, 0, "markdown")
          if ok then p:invalidate(true) end
          require("quarto.runner").run_all()
        end,
        desc = "Run all cells",
      },
      { "<localleader>rl", function() require("quarto.runner").run_line() end,  desc = "Run line" },
      {
        "<localleader>r",
        function()
          local ok, p = pcall(vim.treesitter.get_parser, 0, "markdown")
          if ok then p:invalidate(true) end
          require("quarto.runner").run_range()
        end,
        desc = "Run selection",
        mode = "v",
      },
      {
        "<localleader>RA",
        function()
          local ok, p = pcall(vim.treesitter.get_parser, 0, "markdown")
          if ok then p:invalidate(true) end
          require("quarto.runner").run_all(true)
        end,
        desc = "Run all cells (all languages)",
      },
    },
  },
}
