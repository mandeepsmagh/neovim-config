return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "b0o/SchemaStore.nvim",
        "Hoffs/omnisharp-extended-lsp.nvim"
    },

    config = function()
        -- Reusable on_attach function
        local on_attach = function(client, bufnr)
            print("LSP attached to buffer for " .. vim.bo[bufnr].filetype)

            -- Enable inlay hints if supported
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true)
            end
        end

        -- Set up nvim-cmp
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- Set up fidget.nvim
        require("fidget").setup({})

        -- Set up mason and mason-lspconfig
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "ts_ls",
                "omnisharp",
                "jsonls",
                "bashls",
                "html",
                "cssls"
            },
            automatic_installation = true,
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    }
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                            },
                        },
                        on_attach = on_attach,
                    }
                end,
                ["rust_analyzer"] = function()
                    require("lspconfig").rust_analyzer.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            ["rust-analyzer"] = {}
                        }
                    }
                end,
                ["omnisharp"] = function()
                    --local pid = vim.fn.getpid()
                    require("lspconfig").omnisharp.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        handlers = {
                            ["textDocument/definition"] = require('omnisharp_extended').handler,
                        },
                        cmd = { "dotnet", vim.fn.expand("$MASON/packages/omnisharp/libexec/OmniSharp.dll") },
                        -- Enable roslyn analyzers, code style settings from .editorconfig
                        enable_roslyn_analyzers = true,
                        organize_imports_on_format = true,
                        enable_import_completion = true,
                        sdk_include_prereleases = true,
                        enable_editorconfig_support = true,
                        root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git")
                    }
                end,
                ["ts_ls"] = function()
                    require("lspconfig").ts_ls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            javascript = { format = { enable = true } },
                            typescript = { format = { enable = true } },
                        }
                    }
                end,
                ["bashls"] = function()
                    require("lspconfig").bashls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    }
                end,
                ["jsonls"] = function()
                    require("lspconfig").jsonls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            json = {
                                schemas = require('schemastore').json.schemas(),
                                validate = { enable = true },
                            },
                        },
                    }
                end,
            }
        })

        -- Set up nvim-cmp with LuaSnip
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        -- Set up diagnostic config
        vim.diagnostic.config({
            float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
