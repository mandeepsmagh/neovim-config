vim.g.mapleader = " "
vim.g.maplocalleader = " "

local utils = require("user.utils")
local keymap = vim.keymap.set
local opts = { silent = true }

local function map(mode, lhs, rhs, extra_opts)
    local options = vim.tbl_extend("force", opts, extra_opts or {})
    keymap(mode, lhs, rhs, options)
end

-------------------- LEADER ------------------------------
map("n", "<Space>", "<Nop>", { desc = "Disable Space motion" })

-------------------- File operations ------------------------------
map({ "n", "i" }, "<C-s>", "<Esc><cmd>up<cr>", { desc = "Save file" })
map("n", "QQ", ":qa!<CR>", { desc = "quit all without saving" })

-------------------- EDITING ------------------------------
map("i", "<C-u>", "<C-g>u<C-u>", { desc = "Undo-friendly clear-to-start" })
map("i", "<C-w>", "<C-g>u<C-w>", { desc = "Undo-friendly delete-word" })
map("i", "jj", "<Esc>", { desc = "Exit insert" })
map("n", "<leader>a", "ggVG", { desc = "Select all" })

map("n", "<leader>cb", function()
    vim.api.nvim_put({ "```", "", "```" }, "l", true, true)
    vim.cmd("normal! k")
end, { desc = "Insert fenced code block" })

-- Visual P pastes over the selection without overwriting the register (:h v_P)

-------------------- MOVEMENT ------------------------------
-- wrap is on: move by screen line unless a count is given
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (screen line)" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (screen line)" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("x", "<A-Down>", ":move '>+1<CR>gv-gv", { desc = "Move selection down" })
map("x", "<A-Up>", ":move '<-2<CR>gv-gv", { desc = "Move selection up" })
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move selection down" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move selection up" })

map("x", "<", "<gv", { desc = "Indent left, keep selection" })
map("x", ">", ">gv", { desc = "Indent right, keep selection" })

-------------------- WINDOWS ------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<leader>s", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Split vertical" })

-------------------- UTILITIES ------------------------------
map("n", "<Esc><Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })
map("n", "<leader>o", "m`o<Esc>``", { desc = "Insert blank line below" })
map("n", "<leader>nm", utils.CreateNote, { desc = "Create note" })

-- nvim-tree -------------------------------------------------
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
map("n", "<leader>r", "<cmd>NvimTreeFindFile<cr>", { desc = "Reveal file in tree" })

-------------------- LSP ------------------------------
map("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "Go to declaration" })
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "<leader>D", function() vim.lsp.buf.type_definition() end, { desc = "Go to type definition" })
map("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
map({ "n", "v" }, "<leader>f", function()
    vim.lsp.buf.format({ async = false })
end, { desc = "Format buffer or range" })

map("n", "gl", function() vim.diagnostic.open_float() end, { desc = "Show diagnostic" })
map("n", "<leader>dq", function() vim.diagnostic.setloclist() end, { desc = "Diagnostics to loclist" })

-- Neovim 0.12+ built-in LSP + native keymaps -- not mapped
-- above because Vim already does this out of the box:
-- ZZ / ZQ  -> save & quit / quit
-- K        -> vim.lsp.buf.hover()
-- grr      -> vim.lsp.buf.references()
-- gri      -> vim.lsp.buf.implementation()
-- grn      -> vim.lsp.buf.rename()
-- gra      -> vim.lsp.buf.code_action()
-- grt      -> vim.lsp.buf.type_definition()
-- grx      -> vim.lsp.codelens.run()
-- gO       -> vim.lsp.buf.document_symbol()
-- gq       -> format (operator)
-- [d, ]d   -> diagnostic navigation
-- <C-s>    -> vim.lsp.buf.signature_help() (insert mode) - conflicts with save
