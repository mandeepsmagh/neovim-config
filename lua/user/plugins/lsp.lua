return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                ui = { border = "rounded" }
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
                    "omnisharp",
                    "jsonls",
                    "bashls",
                    "html",
                    "cssls",
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
        "Hoffs/omnisharp-extended-lsp.nvim",
        ft = "cs",
    },

    -- Native LSP Configuration
    {
        name = "native-lsp",
        dir = vim.fn.stdpath("config"),
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
            "blink.cmp",
            "SchemaStore.nvim",
            "omnisharp-extended-lsp.nvim",
        },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- Wait a bit to ensure Mason binaries are available
            vim.defer_fn(function()
                local capabilities = require("blink.cmp").get_lsp_capabilities()

                local on_attach = function(client, bufnr)
                    print("LSP attached to buffer for " .. vim.bo[bufnr].filetype)
                    if client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end

                -- Native Neovim LSP setup
                vim.lsp.config.lua_ls = {
                    cmd = { "lua-language-server" },
                    filetypes = { "lua" },
                    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = {
                                disable = { "undefined-field", "missing-fields" },
                                globals = { "vim" }
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            telemetry = { enable = false },
                        },
                    },
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                vim.lsp.config.rust_analyzer = {
                    cmd = { "rust-analyzer" },
                    filetypes = { "rust" },
                    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            checkOnSave = true,
                            check = {
                                command = "clippy",
                                workspace = false -- Use -p instead of --workspace
                            },
                        },
                    },
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                vim.lsp.config.ts_ls = { -- Fixed: was tsserver, now ts_ls
                    cmd = { "typescript-language-server", "--stdio" },
                    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
                    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
                    settings = {
                        javascript = { format = { enable = true } },
                        typescript = { format = { enable = true } },
                    },
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                vim.lsp.config.omnisharp = {
                    cmd = { "omnisharp" },
                    filetypes = { "cs" },
                    root_markers = { "*.sln", "*.csproj", ".git" },
                    settings = {
                        FormattingOptions = {
                            EnableEditorConfigSupport = true,
                            OrganizeImports = true,
                        },
                        RoslynExtensionsOptions = {
                            EnableAnalyzersSupport = true,
                            EnableImportCompletion = true,
                        },
                    },
                    capabilities = capabilities,
                    on_attach = on_attach,
                    handlers = {
                        ["textDocument/definition"] = function(...)
                            return require("omnisharp_extended").handler(...)
                        end,
                    },
                }

                vim.lsp.config.jsonls = {
                    cmd = { "vscode-json-language-server", "--stdio" },
                    filetypes = { "json", "jsonc" },
                    root_markers = { "package.json", ".git" },
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true },
                        },
                    },
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                vim.lsp.config.bashls = {
                    cmd = { "bash-language-server", "start" },
                    filetypes = { "sh", "bash" },
                    root_markers = { ".git" },
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                vim.lsp.config.html = {
                    cmd = { "vscode-html-language-server", "--stdio" },
                    filetypes = { "html" },
                    root_markers = { "package.json", ".git" },
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                vim.lsp.config.cssls = {
                    cmd = { "vscode-css-language-server", "--stdio" },
                    filetypes = { "css", "scss", "less" },
                    root_markers = { "package.json", ".git" },
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                -- Enable all servers (fixed server names)
                vim.lsp.enable({
                    "lua_ls",
                    "rust_analyzer",
                    "ts_ls", -- Fixed: was tsserver
                    "omnisharp",
                    "jsonls",
                    "bashls",
                    "html",
                    "cssls",
                })

                -- Diagnostics configuration
                vim.diagnostic.config({
                    virtual_text = true,
                    signs = true,
                    underline = true,
                    update_in_insert = false,
                    severity_sort = true,
                    float = {
                        focusable = true,
                        style = "minimal",
                        border = "rounded",
                        source = "if_many",
                    },
                })

                -- Diagnostic signs
                local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
                for type, icon in pairs(signs) do
                    local hl = "DiagnosticSign" .. type
                    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
                end

                vim.api.nvim_create_user_command("LspInfo", function()
                    local clients = vim.lsp.get_clients()
                    if next(clients) == nil then
                        print("No LSP clients attached")
                    else
                        for _, client in pairs(clients) do
                            print(string.format("Client: %s (id: %d)", client.name, client.id))
                        end
                    end
                end, {})
            end, 100) -- 100ms delay to ensure Mason is ready
        end,
    },
}
