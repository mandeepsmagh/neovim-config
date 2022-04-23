require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'material',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    -- lualine_c = { 'lsp_progress' },
    lualine_d = {function()
      return require'nvim-treesitter'.statusline(40)
    end},
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },

  },
}

