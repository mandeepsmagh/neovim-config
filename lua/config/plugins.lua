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
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = true
    },
    {
        'nvim-telescope/telescope.nvim',
        lazy = true
    },
    {
        'nvim-lua/plenary.nvim',
        lazy = true
    },
    {
        'nvim-lua/popup.nvim',
        lazy = true
    },
    
    {
        'nvim-tree/nvim-tree.lua',
        lazy = true,
        opts = { on_attach = on_attach_change }
    },
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true
    },
    {
        'akinsho/bufferline.nvim',
        lazy = true
    },
    {
        'navarasu/onedark.nvim',
        lazy = true
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = true
    },
    {
        'sakhnik/nvim-gdb',
        lazy = true
    },
    {
        'nvim-lualine/lualine.nvim',
        lazy = true
    },
    {
        'numToStr/Comment.nvim',
        lazy = true
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    {
        'nvim-orgmode/orgmode',
        lazy = true
    },
    {
        'tpope/vim-fugitive',
        lazy = true
    },
    {
        'akinsho/toggleterm.nvim',
        lazy = true
    },
    {
        'b0o/SchemaStore.nvim',
        lazy = true
    },
    {
        'windwp/nvim-autopairs', -- Autopairs, integrates with both cmp and treesitter
        lazy = true
    },
    {
        'goolord/alpha-nvim',
        lazy = true
    },
    {
        'RRethy/vim-illuminate', -- highlight selected
        lazy = true
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        lazy = true
    },
    -- cmp plugins
    {
        'hrsh7th/nvim-cmp', -- The completion plugin
        lazy = true
    },
    {
        'hrsh7th/cmp-buffer', -- buffer completions
        lazy = true
    },
    {
        'hrsh7th/cmp-path', -- path completions
        lazy = true
    },
    {
        'hrsh7th/cmp-cmdline', -- cmdline completions
        lazy = true
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        lazy = true
    },
    {
        'hrsh7th/cmp-nvim-lua',
        lazy = true
    },
    -- snippets
    {
        'L3MON4D3/LuaSnip', -- snippet completions
        lazy = true

    },
    {
        'saadparwaiz1/cmp_luasnip', -- used together with above plugin
        lazy = true
    },
    {
        'rafamadriz/friendly-snippets', -- some extra snippets
        lazy = true
    },
    -- LSP
    {
        'neovim/nvim-lspconfig', -- enable LSP
        lazy = true
    },
    {
        'williamboman/mason.nvim',
    },
    {
        'williamboman/mason-lspconfig.nvim', -- simple to use language server installer
    },
    {
        'tamago324/nlsp-settings.nvim', -- language server settings defined in json for
        lazy = true
    },
    {
        'jose-elias-alvarez/null-ls.nvim', -- for formatters and linters
        lazy = true
    },
    {
        --Java Debugging plugin---
        'mfussenegger/nvim-jdtls',
        lazy = true
    },
    -- debugging
    {
        'mfussenegger/nvim-dap',
        lazy = true
    },
    {
        'rcarriga/nvim-dap-ui',
        lazy = true
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        lazy = true
    },
    {
        'nvim-telescope/telescope-dap.nvim',
        lazy = true
    }
}

-- Initialize lazy.nvim with your plugins
return lazy.setup(plugins, op)
