-- Activate quarto-nvim for markdown buffers (provides LSP via otter + code runner).
-- This is the recommended approach from molten-nvim's Notebook-Setup guide.
-- quarto-nvim must have ft = { "quarto", "markdown" } in its lazy.nvim spec.
--
-- We defer activation with vim.schedule() so treesitter has time to parse the
-- buffer and create injection children (python, bash, etc.) before otter tries
-- to extract code chunks.  Without this, buffers loaded by jupytext's BufReadCmd
-- often have empty parser:children() when quarto.activate() runs synchronously
-- during the FileType event, causing "No code chunks found" errors in run_cell().
vim.schedule(function()
  -- Guard: only activate if the buffer still exists and is the right filetype
  local buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "markdown" then
    -- Force a full treesitter parse (including injections) before activation
    local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
    if ok and parser then
      parser:parse(true)
    end
    require("quarto").activate()
  end
end)
