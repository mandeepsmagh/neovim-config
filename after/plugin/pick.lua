vim.pack.add({
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/echasnovski/mini.extra" },
})

local pick = require("mini.pick")
local extra = require("mini.extra")

pick.setup({
    window = {
        config = function()
            local height = math.floor(vim.o.lines * 0.80)
            local width = math.floor(vim.o.columns * 0.87)

            return {
                anchor = "NW",
                height = height,
                width = width,
                row = math.floor((vim.o.lines - height) / 2),
                col = math.floor((vim.o.columns - width) / 2),
                border = "rounded",
            }
        end,
        prompt_prefix = " ",
    },
})

-- Use mini.pick as the default UI selector for plugins that call vim.ui.select()
vim.ui.select = pick.ui_select

local builtin = pick.builtin
local pickers = extra.pickers
local map = vim.keymap.set

-- Files
map("n", "<C-p>", function()
    builtin.files({ tool = "rg" })
end, { desc = "Find files" })

-- Live grep
map("n", "<leader>gr", function()
    builtin.grep_live()
end, { desc = "Live grep" })

-- Git commits
map("n", "<leader>gc", function()
    pickers.git_commits()
end, { desc = "Git commits" })

-- Git hunks (closest practical replacement for Telescope git_status)
map("n", "<leader>gs", function()
    pickers.git_hunks()
end, { desc = "Git hunks" })

-- Diagnostics
map("n", "<leader>dg", function()
    pickers.diagnostic()
end, { desc = "Diagnostics" })

-- Nice extra: reopen the last picker
map("n", "<leader><leader>", function()
    builtin.resume()
end, { desc = "Resume picker" })

-- Optional handy extras
map("n", "<leader>fb", function()
    builtin.buffers()
end, { desc = "Buffers" })

map("n", "<leader>fh", function()
    builtin.help()
end, { desc = "Help tags" })
