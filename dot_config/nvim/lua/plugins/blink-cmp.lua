return {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    opts = {
        keymap = { preset = "default" },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
        },
        signature = { enabled = true },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "lazydev" },
            providers = {
                snippets = { opts = { friendly_snippets = true } },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
            },
        },
    },
}
