local utils = require("user.utils")
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, extra_opts)
    local options = vim.tbl_extend("force", opts, extra_opts or {})
    keymap(mode, lhs, rhs, options)
end

-------------------- MAPPINGS ------------------------------
map("n", "<Space>", "")    -- space as leader
vim.g.mapleader = " "      -- space as leader
vim.g.maplocalleader = " " -- space as local leader

-- File operations
-- map("n", "zz", ":up<CR>")        -- save file
map({ "n", "i" }, "<C-s>", "<Esc>:up<CR>") -- save file
map("n", "<leader>z", ":up<CR>")           -- Save file
map("n", "qq", ":q!<CR>")                  -- quit without saving
map("n", "QQ", ":qa!<CR>")                 -- quit all without saving

-- Better editing
map("i", "<C-u>", "<C-g>u<C-u>") -- Make <C-u> undo-friendly
map("i", "<C-w>", "<C-g>u<C-w>") -- Make <C-w> undo-friendly
map("i", "jj", "<Esc>")          -- Escape key mapped to jj
map("n", ";", ":")               -- Command mode
map("n", "<leader>a", "ggVG")    -- select All

-- Smart paste and delete
map("v", "p", '"_dP') -- Better paste in visual mode
map("", "dd", '"_dd') -- don't save deleted content

-- Clipboard operations
map("", "y", '"+y')          -- Copy to clipboard in normal, visual, select and operator modes
map("", "yy", '"+yy')        -- Copy to clipboard in normal, visual, select and operator modes
map("", "p", '"+p')          -- paste after cursor from clipboard in normal, visual, select and operator modes
map("", "P", '"+P')          -- paste before cursor
map("", "<leader>p", '"_dP') -- delete and paste

-- Move macro recording to <leader>q
map("n", "q", "<Nop>")                                         -- Disable macro recording on q to avoid accidental macro recording
map("n", "<leader>q", "q", { desc = "Start macro recording" }) -- Move to leader+q

-- Markdown notes
map("n", "<leader>nm", utils.CreateNote)

-- Window management
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize +2<CR>")
map("n", "<C-Right>", ":vertical resize -2<CR>")

-- Move text up and down
map("n", "<A-Down>", ":m .+1<CR>==gi")
map("n", "<A-Up>", ":m .-2<CR>==gi")
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi")
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi")
map("v", "<A-Down>", ":m .+1<CR>==")
map("v", "<A-Up>", ":m .-2<CR>==")

-- Visual Block movement
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-Down>", ":move '>+1<CR>gv-gv")
map("x", "<A-Up>", ":move '<-2<CR>gv-gv")

-- Indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Utilities
map("n", "<ESC><ESC>", "<cmd>noh<CR>") -- Clear highlights
map("n", "<leader>o", "m`o<Esc>``")    -- Insert a newline in normal mode

-- File tree
map("n", "<leader>n", ":NvimTreeToggle<CR>")  -- open/close
map("n", "<leader>r", ":NvimTreeRefresh<CR>") -- refresh

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<CR>")
map("n", "<leader>gr", "<cmd>Telescope live_grep<CR>")
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>")
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>")
map("n", "<leader>dg", "<cmd>Telescope diagnostics<CR>")

-- Split screen
map("n", "<leader>s", "<cmd>split<CR>")  -- horizontal split
map("n", "<leader>v", "<cmd>vsplit<CR>") -- vertical split
map("n", "<C-h>", "<C-w>h")              -- move to left
map("n", "<C-j>", "<C-w>j")              -- move to below
map("n", "<C-k>", "<C-w>k")              -- move to above
map("n", "<C-l>", "<C-w>l")              -- move to right

-- LSP keymaps
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature help" })

-- Diagnostics
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic" })
map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "Diagnostics to loclist" })

-- Neovim 0.11+ Built-in LSP keymaps
-- K        -> vim.lsp.buf.hover()
-- grr      -> vim.lsp.buf.references()
-- gri      -> vim.lsp.buf.implementation()
-- grn      -> vim.lsp.buf.rename()
-- gra      -> vim.lsp.buf.code_action()
-- [d, ]d   -> diagnostic navigation
-- <C-s>    -> vim.lsp.buf.signature_help() (insert mode) - conflicts with save
