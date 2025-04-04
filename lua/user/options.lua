local M = {}
local set = vim.opt

-- Basic editor settings
set.fileencoding = "utf-8"
set.spelllang = "en"
-- enable clipboard only if not in ssh mode
-- required for OSC 52 integration
set.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
set.mouse = "a"
set.signcolumn = "yes"
set.foldmethod = "manual"
set.completeopt = { "menuone", "noselect" }
set.colorcolumn = "99999"

-- File handling
set.backup = false
set.swapfile = false
set.writebackup = false
set.undofile = true

-- Indentation and formatting
set.autoindent = true -- indent based on previous lines
set.expandtab = true
set.smartindent = true
set.shiftwidth = 4
set.tabstop = 4

-- Search settings
set.hlsearch = true
set.ignorecase = true
set.smartcase = true

-- Visual settings
set.termguicolors = true
set.cursorline = true
set.number = true
set.relativenumber = true
set.wrap = true
set.linebreak = true
set.conceallevel = 2
set.cmdheight = 2
set.scrolloff = 8
set.sidescrolloff = 8
set.pumheight = 10

-- Editor behavior
set.hidden = true
set.spell = false
set.showmode = true
set.splitbelow = true
set.splitright = true
set.history = 100
set.timeoutlen = 300
set.updatetime = 300
set.fillchars = { eob = " " }

-- Return the module
return M
