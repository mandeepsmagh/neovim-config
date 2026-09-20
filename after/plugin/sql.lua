if vim.uv.os_uname().sysname == "Windows_NT" then
    vim.pack.add({
        { src = "https://github.com/Kurren123/mssql.nvim" },
        { src = "https://github.com/folke/which-key.nvim" },
    })

    require("mssql").setup({
        keymap_prefix = "<leader>m",
        max_rows = 1000,
    })
end
