vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
})

local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
    },
    format_on_save = {
        lsp_format = "fallback",
        async = false,
        timeout_ms = 500,
    },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 500,
    })
end, { desc = "Format file or range" })
