local fn = vim.fn

-- Place where packer is goint to be saved
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Install packer from github if not currently installed
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected require call (pcall) so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Show packer messages in a popup. Looks cooler
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})
-------------------- PLUGINS -------------------------------
return packer.startup(function(use)
    use 'wbthomason/packer.nvim'  -- packer itself
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-lua/popup.nvim'
	use 'kyazdani42/nvim-tree.lua'
	use 'kyazdani42/nvim-web-devicons'
	use 'akinsho/bufferline.nvim'
	use 'navarasu/onedark.nvim'
	use 'sakhnik/nvim-gdb'
	use 'nvim-lualine/lualine.nvim'
	use 'numToStr/Comment.nvim'
    use 'nvim-orgmode/orgmode'
    use 'tpope/vim-fugitive'
    use 'akinsho/toggleterm.nvim'
	 -- cmp plugins
	use 'hrsh7th/nvim-cmp' -- The completion plugin
	use 'hrsh7th/cmp-buffer' -- buffer completions
	use 'hrsh7th/cmp-path' -- path completions
	use 'hrsh7th/cmp-cmdline' -- cmdline completions
	use 'saadparwaiz1/cmp_luasnip' -- snippet completions
	use 'hrsh7th/cmp-nvim-lsp'
	-- LSP
	use 'neovim/nvim-lspconfig'          -- enable LSP
	use 'williamboman/nvim-lsp-installer' -- simple to use language server installer
	use 'tamago324/nlsp-settings.nvim'    -- language server settings defined in json for
	use 'jose-elias-alvarez/null-ls.nvim' -- for formatters and linters
    -- debugging
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'nvim-telescope/telescope-dap.nvim'
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)

