-- plugin/lsp.lua

vim.pack.add({
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/b0o/SchemaStore.nvim" },
    { src = "https://github.com/seblyng/roslyn.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saghen/blink.cmp",                 version = vim.version.range("^1") },
})

-- ── Mason ─────────────────────────────────────────────────────────────
-- Must be setup BEFORE roslyn.nvim registers its mason integration
require("mason").setup({
    ui = { border = "rounded" },
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry", -- required for roslyn
    },
})

-- Only manage non-roslyn servers here. Roslyn is NOT in mason-lspconfig,
-- so don't list it here. automatic_enable handles the rest via after/lsp/.
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls", "rust_analyzer", "ts_ls", "jsonls",
        "bashls", "html", "cssls", "tinymist",
    },
    -- automatic_enable = true will call vim.lsp.enable() for the above.
    -- This is fine as long as you have matching after/lsp/<name>.lua files
    -- (or rely on nvim-lspconfig's bundled lsp/ configs).
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
    fuzzy = { implementation = "prefer_rust_with_warning" }, -- top-level, not under completion
})

-- ── Roslyn (C#) ───────────────────────────────────────────────────────
-- LSP settings (capabilities, on_attach, settings) go in vim.lsp.config().
require("roslyn").setup({
    -- filewatching: "auto" | "roslyn" | "off"
    filewatching = "auto",
    broad_search = false,
    lock_target = false,
    silent = false,
})

-- ── Roslyn LSP config (settings/capabilities) ─────────────────────────
-- This is the correct place for everything that was wrongly inside roslyn.setup()
vim.lsp.config("roslyn", {
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
        ["csharp|completion"] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
        },
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
        },
    },
})
