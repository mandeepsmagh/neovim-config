vim.pack.add({
    { src = "https://github.com/echasnovski/mini.icons" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

require("mini.icons").setup({})
require("mini.icons").mock_nvim_web_devicons()

require("nvim-tree").setup({
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 500,
    },
})
