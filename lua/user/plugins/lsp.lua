return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                ui = { border = "rounded" },
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry", -- Custom registry for Roslyn
                },
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        lazy = false,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "ts_ls",
                    "jsonls",
                    "bashls",
                    "html",
                    "cssls",
                    "tinymist"
                },
                automatic_installation = true,
            })
        end,
    },

    {
        "saghen/blink.cmp",
        version = "v0.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            completion = { documentation = { auto_show = true } },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        },
    },

    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },

    {
        "b0o/SchemaStore.nvim",
        lazy = true,
    },
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        opts = {
            -- your configuration comes here; leave empty for default settings
        },
    }
}
