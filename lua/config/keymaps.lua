local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- MAPPINGS ------------------------------
cmd 'let mapleader = "\\<space>"'   -- space as leader key
map('n', 'zz', ':up<CR>')            -- save file
map('', '<leader>c', '"+y')          -- Copy to clipboard in normal, visual, select and operator modes
map('n', '<leader>z', ':up<CR>')     -- Save file
map('i', '<C-u>', '<C-g>u<C-u>')     -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')     -- Make <C-w> undo-friendly

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

-- Resize with arrows
map('n', '<C-Up>', ':resize +2<CR>')
map('n', '<C-Down>', ':resize -2<CR>')
map('n', '<C-Left>', ':vertical resize +2<CR>')
map('n', '<C-Right>', ':vertical resize -2<CR>')

-- Move text up and down
map("n", "<A-Down>", "<Esc>:m .+1<CR>==gi")
map("n", "<A-Up>", "<Esc>:m .-2<CR>==gi")

map("v", "<A-Down>", ":m .+1<CR>==")
map("v", "<A-Up>", ":m .-2<CR>==")
map("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-Down>", ":move '>+1<CR>gv-gv")
map("x", "<A-Up>", ":move '<-2<CR>gv-gv")

-- Indent
map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

---nvim-tree-mappings-------------------
map('n', '<leader>n', ':NvimTreeToggle<CR>')    -- open/close
map('n', '<leader>r', ':NvimTreeRefresh<CR>')   -- refresh

--Telescope-----------------------------
map("n", "<leader>f", "<cmd>Telescope find_files<CR>")

--debugging-------------------------------
map("n", "<F5>", ":lua require'dap'.continue()<CR>")
map("n", "<F10>", ":lua require'dap'.step_over()<CR>")
map("n", "<F11>", ":lua require'dap'.step_into()<CR>")
map("n", "<F9>", ":lua require'dap'.step_out()<CR>")
map("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
map("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
map("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
