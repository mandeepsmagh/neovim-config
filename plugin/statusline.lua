vim.pack.add({
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/echasnovski/mini.icons" },
})

require("mini.icons").setup()

-- ── Lualine ───────────────────────────────────────────────────────────
local sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
}

-- Conditionally add MSSQL component if available
local ok, mssql = pcall(require, "mssql")
if ok and mssql.lualine_component then
    table.insert(sections.lualine_c, mssql.lualine_component)
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
    },
    sections = sections,
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {},
})
