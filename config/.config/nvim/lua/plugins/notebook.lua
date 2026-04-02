-- Jupyter notebook support
-- Stack: jupytext.nvim (ipynb <-> markdown) + molten-nvim (run cells, show output)
--        + quarto-nvim/otter.nvim (LSP in cells) + image.nvim (inline plots)
--
-- Activation: quarto is activated for markdown buffers via ftplugin/markdown.lua
-- (per molten-nvim's official Notebook-Setup guide).

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
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_wrap_output = true
    end,
    keys = {
      { "<localleader>mi", "<cmd>MoltenInit<cr>",                          desc = "Molten init kernel" },
      { "<localleader>e",  "<cmd>MoltenEvaluateOperator<cr>",              desc = "Molten eval operator" },
      { "<localleader>ml", "<cmd>MoltenEvaluateLine<cr>",                  desc = "Molten run line" },
      { "<localleader>mr", "<cmd>MoltenReevaluateCell<cr>",                desc = "Molten re-run cell" },
      { "<localleader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv",             desc = "Molten run selection", mode = "v" },
      { "<localleader>md", "<cmd>MoltenDelete<cr>",                        desc = "Molten delete cell" },
      { "<localleader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>",         desc = "Molten open output" },
      { "<localleader>mh", "<cmd>MoltenHideOutput<cr>",                    desc = "Molten hide output" },
    },
    config = function()
      -- Auto-init kernel + import outputs when opening a notebook
      -- (from molten-nvim Notebook-Setup guide)
      local init_molten_buffer = function(e)
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

      vim.api.nvim_create_autocmd("BufAdd", {
        pattern = { "*.ipynb" },
        callback = init_molten_buffer,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.ipynb" },
        callback = function(e)
          if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            init_molten_buffer(e)
          end
        end,
      })

      -- Auto-export outputs on save
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.ipynb" },
        callback = function()
          if require("molten.status").initialized() == "Molten" then
            vim.cmd("MoltenExportOutput!")
          end
        end,
      })
    end,
  },

  -- otter.nvim: LSP features inside embedded code blocks
  {
    "jmbuhr/otter.nvim",
    lazy = true,
  },

  -- quarto-nvim: orchestrates otter + code runner for markdown notebooks
  -- Activated for markdown buffers via ftplugin/markdown.lua
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
        chunks = "all", -- detect both ```python and ```{python} fences
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
    keys = {
      { "<localleader>rc", function() require("quarto.runner").run_cell() end,  desc = "Run cell" },
      { "<localleader>ra", function() require("quarto.runner").run_above() end, desc = "Run cell and above" },
      { "<localleader>rA", function() require("quarto.runner").run_all() end,   desc = "Run all cells" },
      { "<localleader>rl", function() require("quarto.runner").run_line() end,  desc = "Run line" },
      { "<localleader>r",  function() require("quarto.runner").run_range() end, desc = "Run selection", mode = "v" },
      {
        "<localleader>RA",
        function() require("quarto.runner").run_all(true) end,
        desc = "Run all cells (all languages)",
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)

      -- :NotebookDiag — diagnostic command for debugging treesitter injection
      -- and otter/quarto activation state.  Run this in a notebook buffer if
      -- ,rc / ,rA report "No code chunks found".
      vim.api.nvim_create_user_command("NotebookDiag", function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype
        local lines = { "--- NotebookDiag ---" }

        -- 1. Filetype
        table.insert(lines, ("filetype: %s"):format(ft))

        -- 2. Treesitter parser
        local parser_ok, parser = pcall(vim.treesitter.get_parser, buf, vim.treesitter.language.get_lang(ft) or ft)
        if not parser_ok then
          table.insert(lines, "parser: FAILED to get (" .. tostring(parser) .. ")")
        else
          table.insert(lines, ("parser: %s"):format(parser:lang()))
          -- Force a full parse
          parser:parse(true)
          -- Children (injected languages)
          local children = parser:children()
          local child_keys = vim.tbl_keys(children)
          table.insert(lines, ("injected languages: %s"):format(#child_keys > 0 and table.concat(child_keys, ", ") or "NONE"))
          for _, lang in ipairs(child_keys) do
            local child = children[lang]
            local regions = child:included_regions()
            local count = 0
            for _ in pairs(regions) do count = count + 1 end
            table.insert(lines, ("  %s: %d region(s)"):format(lang, count))
          end
        end

        -- 3. Injection query
        local lang = vim.treesitter.language.get_lang(ft) or ft
        local query = vim.treesitter.query.get(lang, "injections")
        table.insert(lines, ("injection query (%s): %s"):format(lang, query and "loaded" or "NIL (not found)"))

        -- 4. Otter raft state
        local keeper_ok, keeper = pcall(require, "otter.keeper")
        if keeper_ok and keeper.rafts and keeper.rafts[buf] then
          local raft = keeper.rafts[buf]
          local chunks = raft.code_chunks or {}
          local chunk_langs = vim.tbl_keys(chunks)
          table.insert(lines, ("otter raft: active (languages: %s)"):format(
            #chunk_langs > 0 and table.concat(chunk_langs, ", ") or "none"
          ))
          for _, l in ipairs(chunk_langs) do
            table.insert(lines, ("  %s: %d chunk(s)"):format(l, #chunks[l]))
          end
        else
          table.insert(lines, "otter raft: NOT active for this buffer")
        end

        -- 5. Molten status
        local molten_ok, molten_status = pcall(function() return require("molten.status").initialized() end)
        table.insert(lines, ("molten: %s"):format(molten_ok and molten_status or "not loaded"))

        -- Print
        for _, line in ipairs(lines) do
          vim.api.nvim_echo({{ line, "Normal" }}, true, {})
        end
      end, { desc = "Diagnose notebook treesitter/otter/molten state" })
    end,
  },
}
