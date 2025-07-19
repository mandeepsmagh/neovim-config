return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "html",
                    "css",
                    "typescript",
                    "javascript",
                    "tsx",
                    "json",
                    "bash",
                    "rust",
                    "c_sharp",
                    "gitignore",
                    "sql",
                    "markdown",
                    "markdown_inline",
                    "vim",
                    "vimdoc",
                },

                -- Installation settings
                sync_install = false,
                auto_install = true,

                -- Core modules
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                indent = {
                    enable = true,
                },

                -- Incremental selection
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = "<C-s>",
                        node_decremental = "<M-space>",
                    },
                },

                -- Text objects (requires nvim-treesitter-textobjects plugin)
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- Classes
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",

                            -- Functions
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",

                            -- Parameters/arguments
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",

                            -- Loops
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",

                            -- Conditionals
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",

                            -- Comments
                            ["a/"] = "@comment.outer",
                            ["i/"] = "@comment.inner",

                            -- Blocks
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                        },
                    },

                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        },
                    },
                },
            })
        end,
    },
}
