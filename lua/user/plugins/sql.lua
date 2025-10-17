return {
    "Kurren123/mssql.nvim",
    cond = vim.loop.os_uname().sysname == "Windows_NT",
    opts = {
        -- optional
        keymap_prefix = "<leader>m"
    },
    -- optional
    dependencies = { "folke/which-key.nvim" }
}
