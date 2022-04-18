local fmt = string.format
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
	 {'akinsho/bufferline.nvim'},
	 {'navarasu/onedark.nvim'},
	 {'sakhnik/nvim-gdb'},
	 {'vim-airline/vim-airline'},
	 {'numToStr/Comment.nvim'},
	 {'neoclide/coc.nvim', branch='release'}
}

