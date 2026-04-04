vim.pack.add({
    { src = "https://github.com/akinsho/toggleterm.nvim" },
})

require("toggleterm").setup({
    open_mapping = [[<C-\>]],
    direction = "float",
    float_opts = { border = "rounded" },
})
