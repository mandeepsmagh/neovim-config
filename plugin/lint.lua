vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-lint" },
})

local lint = require("lint")

lint.linters_by_ft = {
    yaml = { "yamllint" },
}
