local utils = require("user.utils")
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, extra_opts)
    local options = vim.tbl_extend("force", opts, extra_opts or {})
    keymap(mode, lhs, rhs, options)
end
-------------------- MAPPINGS ------------------------------
map("n", "<Space>", "")          -- space as leader
vim.g.mapleader = " "            -- space as leader
vim.g.maplocalleader = " "       -- space as local leader
map("n", "zz", ":up<CR>")        -- save file
map("", "y", '"+y')              -- Copy to clipboard in normal, visual, select and operator modes
map("", "yy", '"+yy')            -- Copy to clipboard in normal, visual, select and operator modes
map("", "p", '"+p')              -- paste after cursor from clipboard in normal, visual, select and operator modes
map("", "P", '"+P')              -- paste before cursor
map("n", "<leader>z", ":up<CR>") -- Save file
map("i", "<C-u>", "<C-g>u<C-u>") -- Make <C-u> undo-friendly
map("i", "<C-w>", "<C-g>u<C-w>") -- Make <C-w> undo-friendly
map("n", "qq", ":q!<CR>")        -- quit without saving
map("n", "QQ", ":qa!<CR>")       -- quit all without saving
map("i", "jj", "<Esc>")          -- Escape key mapped to jj
map("n", ";", ":")               -- Command mode
map("n", "<leader>a", "ggVG")    -- select All
map("", "<leader>p", '"_dP')     -- delete and paste
map("", "dd", '"_dd')            -- don't save deleted content

-- <Tab> to navigate the completion menu
map("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {
    expr = true,
})
map("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {
    expr = true,
})

-- Markdown notes
map("n", "<leader>nm", utils.CreateNote)

-- Resize with arrows
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

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-Down>", ":move '>+1<CR>gv-gv")
map("x", "<A-Up>", ":move '<-2<CR>gv-gv")

-- Indent
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<ESC><ESC>", "<cmd>noh<CR>") -- Clear highlights
map("n", "<leader>o", "m`o<Esc>``")    -- Insert a newline in normal mode

---nvim-tree-mappings-------------------
map("n", "<leader>n", ":NvimTreeToggle<CR>")  -- open/close
map("n", "<leader>r", ":NvimTreeRefresh<CR>") -- refresh

-- Telescope-----------------------------
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

-- LSP
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
-- map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
-- map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>")
-- map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
-- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename current symbol" })
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
-- map("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
-- map("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")

-- Format
-- map("n", "<leader>fd", "<cmd>lua vim.lsp.buf.format()<CR>") -- Format document
-- map("v", "<leader>fs", "<ESC><cmd>lua vim.lsp.buf.format({ range = true })<CR>") -- Format selection

-- debugging-------------------------------
map("n", "<F5>", ":lua require'dap'.continue()<CR>")
map("n", "<F10>", ":lua require'dap'.step_over()<CR>")
map("n", "<F11>", ":lua require'dap'.step_into()<CR>")
map("n", "<F9>", ":lua require'dap'.step_out()<CR>")
map("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
map("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
map("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
