-- Neovim's bundled indent/typst.vim forces shiftwidth/softtabstop=2, and it
-- runs after this file. So set the values, then re-apply them once the indent
-- script has finished.
local buf = vim.api.nvim_get_current_buf()
vim.bo[buf].expandtab = true
vim.bo[buf].shiftwidth = 4
vim.bo[buf].softtabstop = 4
vim.schedule(function()
    vim.bo[buf].shiftwidth = 4
    vim.bo[buf].softtabstop = 4
end)
