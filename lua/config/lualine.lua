require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = onedark,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' },
    -- lualine_c = { 'lsp_progress' },
    lualine_c = {function()
      return require'nvim-treesitter'.statusline(40) 
    end},
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },

  },
}

