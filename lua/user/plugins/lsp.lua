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
        "b0o/SchemaStore.nvim"
    },

    config = function()
        -- Reusable on_attach function
        local on_attach = function(client, bufnr)
            print("LSP attached to buffer for " .. vim.bo[bufnr].filetype)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end

            -- Example keybindings
            map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

            -- Enable inlay hints if supported
            
            -- if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            --     vim.lsp.inlay_hint.enable(bufnr, true)  -- Use `enable` instead of directly passing `bufnr`
            --
            --     map("<leader>h", function()
            --         -- Toggle using `enable(bufnr, not is_enabled(bufnr))` instead of non-existent `is_enabled`
            --         vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
            --     end, "[T]oggle Inlay [H]ints")
            -- end
        end

        -- Set up conform.nvim
        require("conform").setup({
            formatters_by_ft = {
                -- Add any specific formatter settings here
            }
        })

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
                "tsserver",
                "omnisharp",
                "jsonls",
                "bashls",
            },
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
                    require("lspconfig").omnisharp.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(pid) },
                        root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git")
                    }
                end,
                ["tsserver"] = function()
                    require("lspconfig").tsserver.setup {
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
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
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
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
