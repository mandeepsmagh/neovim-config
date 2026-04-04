vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
})

-- Install parsers
require("nvim-treesitter").install({
    "lua", "html", "css", "typescript", "javascript",
    "tsx", "json", "bash", "rust", "c_sharp",
    "gitignore", "sql", "markdown", "markdown_inline",
    "vim", "vimdoc",
})

-- Enable highlight + indent per buffer
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- Textobjects config
require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        include_surrounding_whitespace = false,
        selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
        },
    },
    move = {
        enable = true,
        set_jumps = true,
    },
})

-- Select keymaps
local select = require("nvim-treesitter-textobjects.select")
local function sel(query) return function() select.select_textobject(query, "textobjects") end end

vim.keymap.set({ "x", "o" }, "ac", sel("@class.outer"))
vim.keymap.set({ "x", "o" }, "ic", sel("@class.inner"))
vim.keymap.set({ "x", "o" }, "af", sel("@function.outer"))
vim.keymap.set({ "x", "o" }, "if", sel("@function.inner"))
vim.keymap.set({ "x", "o" }, "aa", sel("@parameter.outer"))
vim.keymap.set({ "x", "o" }, "ia", sel("@parameter.inner"))
vim.keymap.set({ "x", "o" }, "al", sel("@loop.outer"))
vim.keymap.set({ "x", "o" }, "il", sel("@loop.inner"))
vim.keymap.set({ "x", "o" }, "ai", sel("@conditional.outer"))
vim.keymap.set({ "x", "o" }, "ii", sel("@conditional.inner"))
vim.keymap.set({ "x", "o" }, "a/", sel("@comment.outer"))
vim.keymap.set({ "x", "o" }, "i/", sel("@comment.inner"))
vim.keymap.set({ "x", "o" }, "ab", sel("@block.outer"))
vim.keymap.set({ "x", "o" }, "ib", sel("@block.inner"))
vim.keymap.set({ "x", "o" }, "aM", sel("@codeblock.outer"))
vim.keymap.set({ "x", "o" }, "iM", sel("@codeblock.inner"))

-- Move keymaps
local move = require("nvim-treesitter-textobjects.move")
local function mv(query, dir, start)
    return function() move.goto_adjacent(query, "textobjects", dir, start) end
end

vim.keymap.set({ "n", "x", "o" }, "]f", mv("@function.outer", true, true))
vim.keymap.set({ "n", "x", "o" }, "]F", mv("@function.outer", true, false))
vim.keymap.set({ "n", "x", "o" }, "[f", mv("@function.outer", false, true))
vim.keymap.set({ "n", "x", "o" }, "[F", mv("@function.outer", false, false))
vim.keymap.set({ "n", "x", "o" }, "]c", mv("@class.outer", true, true))
vim.keymap.set({ "n", "x", "o" }, "]C", mv("@class.outer", true, false))
vim.keymap.set({ "n", "x", "o" }, "[c", mv("@class.outer", false, true))
vim.keymap.set({ "n", "x", "o" }, "[C", mv("@class.outer", false, false))
vim.keymap.set({ "n", "x", "o" }, "]m", mv("@codeblock.outer", true, true))
vim.keymap.set({ "n", "x", "o" }, "]M", mv("@codeblock.outer", true, false))
vim.keymap.set({ "n", "x", "o" }, "[m", mv("@codeblock.outer", false, true))
vim.keymap.set({ "n", "x", "o" }, "[M", mv("@codeblock.outer", false, false))
