vim.pack.add({
    { src = "https://github.com/echasnovski/mini.pairs" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
})

require("mini.pairs").setup()
require("nvim-ts-autotag").setup()
