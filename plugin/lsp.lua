vim.pack.add({
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/b0o/SchemaStore.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saghen/blink.cmp",            version = vim.version.range("^1") },
})

-- ── Mason ─────────────────────────────────────────────────────────────
require("mason").setup({
    ui = { border = "rounded" },
    registries = {
        "github:mason-org/mason-registry",
    },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls", "rust_analyzer", "ts_ls", "jsonls",
        "bashls", "html", "cssls", "tinymist",
    },
    automatic_enable = true,
})

require("fidget").setup({})

require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
    },
    completion = {
        documentation = { auto_show = true },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
})

vim.lsp.enable('roslyn')
