local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
paq {'nvim-treesitter/nvim-treesitter'}
paq {'nvim-telescope/telescope.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-lua/popup.nvim'}
paq {'kyazdani42/nvim-tree.lua'}
paq {'kyazdani42/nvim-web-devicons'}
paq {'navarasu/onedark.nvim'}
paq {'sakhnik/nvim-gdb'}
paq {'nvim-lualine/lualine.nvim'}
paq {'numToStr/Comment.nvim'}
  -- LSP
paq {'neovim/nvim-lspconfig'}           -- enable LSP
paq {'williamboman/nvim-lsp-installer'} -- simple to use language server installer
paq {'tamago324/nlsp-settings.nvim'}    -- language server settings defined in json for
paq {'jose-elias-alvarez/null-ls.nvim'} -- for formatters and linters

