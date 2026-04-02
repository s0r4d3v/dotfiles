-- Activate quarto for markdown buffers (LSP via otter + code runner).
-- Deferred so treesitter injection cache is fully reset before otter
-- extracts code chunks (fixes "No code chunks found" in run_cell).
vim.defer_fn(function()
  local buf = vim.api.nvim_get_current_buf()
  if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "markdown") then
    return
  end
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if ok and parser then
    parser:invalidate(true)
    parser:parse(true)
  end
  require("quarto").activate()
end, 50)
