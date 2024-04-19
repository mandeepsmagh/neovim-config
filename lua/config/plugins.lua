-- Define the path where lazy.nvim should be installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- Check if lazy.nvim is already installed
if not vim.loop.fs_stat(lazypath) then
  -- If not, define the GitHub repository URL
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  
  -- Use git to clone the repository into the defined path
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end

-- Prepend the path of lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Import lazy.nvim
local lazy = require('lazy')

-- Define your plugins
local plugins = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    {
        'nvim-tree/nvim-tree.lua',
        lazy = true,
        opts = { on_attach = on_attach_change }
    },
    'nvim-tree/nvim-web-devicons',
    'akinsho/bufferline.nvim',
    'navarasu/onedark.nvim',
    'EdenEast/nightfox.nvim',
    'sakhnik/nvim-gdb',
    'nvim-lualine/lualine.nvim',
    'numToStr/Comment.nvim',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'nvim-orgmode/orgmode',
    'tpope/vim-fugitive',
    'akinsho/toggleterm.nvim',
    'b0o/SchemaStore.nvim',
    'windwp/nvim-autopairs', -- Autopairs, integrates with both cmp and treesitter
    'goolord/alpha-nvim',
    'RRethy/vim-illuminate', -- highlight selected
    'lukas-reineke/indent-blankline.nvim',
    -- cmp plugins
    'hrsh7th/nvim-cmp', -- The completion plugin
    'hrsh7th/cmp-buffer', -- buffer completions
    'hrsh7th/cmp-path', -- path completions
    'hrsh7th/cmp-cmdline', -- cmdline completions
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    -- snippets
    'L3MON4D3/LuaSnip', -- snippet completions
    'saadparwaiz1/cmp_luasnip', -- used together with above plugin
    'rafamadriz/friendly-snippets', -- some extra snippets
    -- LSP
    'neovim/nvim-lspconfig', -- enable LSP
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim', -- simple to use language server installer
    'tamago324/nlsp-settings.nvim', -- language server settings defined in json for
    'jose-elias-alvarez/null-ls.nvim', -- for formatters and linters
    --Java Debugging plugin---
    'mfussenegger/nvim-jdtls',
    -- debugging
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim'
}

-- Initialize lazy.nvim with your plugins
return lazy.setup(plugins, op)
