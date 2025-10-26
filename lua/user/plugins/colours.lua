return {
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        config = function()
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = true,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
    },
}
