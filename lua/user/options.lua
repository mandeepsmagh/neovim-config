local set = vim.opt

-- Basic editor settings
set.spelllang = "en"
set.clipboard = { "unnamedplus" }
-- enable OSC 52 integration for ssh and WslClipboard for wsl2 only
-- this is to allow paste to work in terminals that don't support osc52 for paste
if vim.env.WSL_DISTRO_NAME then
    vim.g.clipboard = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe",
            ["*"] = "clip.exe",
        },
        paste = {
            ["+"] =
            'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ["*"] =
            'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
elseif vim.env.SSH_TTY then
    vim.g.clipboard = "osc52"
end
set.mouse = "a"
set.signcolumn = "yes"
set.completeopt = { "menuone", "noselect" }
set.confirm = true -- ask to save instead of failing on :q / :e

-- File handling
set.backup = false
set.swapfile = false
set.writebackup = false
set.undofile = true

-- Indentation and formatting
set.expandtab = true
set.smartindent = true
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4

-- Search settings
set.ignorecase = true
set.smartcase = true
set.inccommand = "split" -- show live substitution preview

-- Visual settings
set.termguicolors = true
set.cursorline = true
set.number = true
set.relativenumber = true
set.wrap = true
set.linebreak = true
set.breakindent = true -- wrapped lines keep their indent
set.smoothscroll = true -- scroll by screen line when wrapping
set.conceallevel = 2
set.cmdheight = 2
set.scrolloff = 8
set.sidescrolloff = 8
set.pumheight = 10
set.winborder = "rounded" -- all floating windows
set.laststatus = 3 -- single global statusline
set.showmode = false -- statusline shows the mode
set.fillchars = { eob = " ", fold = " ", foldsep = " " }

-- Folding via treesitter, files open fully unfolded
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
set.foldlevelstart = 99

-- Editor behavior
set.splitbelow = true
set.splitright = true
set.timeoutlen = 500
set.updatetime = 300

-- Disable builtin plugins that are never used (netrw is replaced by nvim-tree)
vim.g.loaded_zip = 1
vim.g.loaded_tar = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
