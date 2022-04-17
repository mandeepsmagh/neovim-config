local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq')  -- a convenient alias
paq {
	'isavq/paq-nvim';  -- paq-nvim manages itself
	'nvim-treesitter/nvim-treesitter';
	'nvim-telescope/telescope.nvim';
	'nvim-lua/plenary.nvim';
	'nvim-lua/popup.nvim';
	'kyazdani42/nvim-tree.lua';
	'kyazdani42/nvim-web-devicons';
	'navarasu/onedark.nvim';
	'sakhnik/nvim-gdb';
	'nvim-lualine/lualine.nvim';
	'numToStr/Comment.nvim';
	-- LSP
	'neovim/nvim-lspconfig';          -- enable LSP
	'williamboman/nvim-lsp-installer'; -- simple to use language server installer
	'tamago324/nlsp-settings.nvim';    -- language server settings defined in json for
	'jose-elias-alvarez/null-ls.nvim'; -- for formatters and linters
}

