return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap     = { preset = "default" },
      appearance = { use_nvim_cmp_as_default = false },
      fuzzy      = { implementation = "lua" }, -- pre-built Rust binaries unavailable on some Linux platforms
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name         = "LazyDev",
            module       = "lazydev.integrations.blink",
            score_offset = 100, -- prioritise over lsp in lua files
          },
        },
      },
    },
  },
}
