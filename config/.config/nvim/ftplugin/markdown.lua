-- Activate quarto-nvim for markdown buffers (provides LSP via otter + code runner).
-- This is the recommended approach from molten-nvim's Notebook-Setup guide.
-- quarto-nvim must have ft = { "quarto", "markdown" } in its lazy.nvim spec.
--
-- PROBLEM: In interactive Neovim, treesitter highlighting (enabled by default in
-- 0.11) creates the markdown parser and calls parse(true) during the first redraw.
-- That initial parse evaluates the injection query and sets an internal field
-- (_processed_injection_range) to "entire document".  If for any reason that first
-- evaluation didn't produce injection children (race with plugin loading, parser
-- .so not yet loadable, or buffer content not fully set by jupytext), subsequent
-- parse(true) calls SKIP injection re-evaluation because the range is already
-- "covered".  This causes parser:children() to return {} (no python), which makes
-- otter find zero code chunks, which makes ,rc / ,rA fail with "No code chunks
-- found".
--
-- FIX: We defer with vim.defer_fn (50ms) to ensure all plugins are loaded and
-- buffer content is fully set, then:
--   1. invalidate(true) — discards all cached trees and resets the C parser
--   2. parse(true)      — re-parses from scratch, which clears
--      _processed_injection_range and forces full injection re-evaluation
-- This guarantees injection children (python, bash, etc.) are correctly created
-- before otter/quarto try to extract code chunks.
vim.defer_fn(function()
  -- Guard: only activate if the buffer still exists and is the right filetype
  local buf = vim.api.nvim_get_current_buf()
  if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "markdown") then
    return
  end

  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if ok and parser then
    -- Nuclear reset: discard all trees + invalidate all regions + reset C parser
    parser:invalidate(true)
    -- Re-parse from scratch — this clears _processed_injection_range (because
    -- regions were re-parsed) and runs _get_injections() to create children.
    parser:parse(true)
  end

  require("quarto").activate()
end, 50)
