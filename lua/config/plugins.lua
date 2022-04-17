local paq_dir = fmt('%s/site/pack/paqs/start/paq-nvim', vim.fn.stdpath('data'))

if vim.fn.empty(vim.fn.glob(paq_dir)) > 0 then
  vim.fn.system {'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_dir}
end

-------------------- PLUGINS -------------------------------
 require'paq'{
	 {'isavq/paq-nvim'},  -- paq-nvim manages itself
	 {'nvim-treesitter/nvim-treesitter'},
	 {'nvim-telescope/telescope.nvim'},
	 {'nvim-lua/plenary.nvim'},
	 {'nvim-lua/popup.nvim'},
	 {'kyazdani42/nvim-tree.lua'},
	 {'kyazdani42/nvim-web-devicons'},
	 {'navarasu/onedark.nvim'},
	 {'sakhnik/nvim-gdb'},
	 {'nvim-lualine/lualine.nvim'},
	 {'numToStr/Comment.nvim'},
	-- LSP
	{'neovim/nvim-lspconfig'},          -- enable LSP
	{'williamboman/nvim-lsp-installer'}, -- simple to use language server installer
	{'tamago324/nlsp-settings.nvim'},    -- language server settings defined in json for
	{'jose-elias-alvarez/null-ls.nvim'} -- for formatters and linters
}

