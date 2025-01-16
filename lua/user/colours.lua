local colors = {
    foreground = '#dbd9ff',
    background = '#0e0d18',
}

local groups = {
    Normal = {
        fg = colors.foreground,
        bg = colors.background
    },
}

return function()
    vim.o.background = 'dark'

    if vim.g.colors_name then
        vim.cmd('highlight clear')
    end

    vim.g.colors_name = 'user'

    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end

    for name, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end
