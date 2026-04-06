return {
    cmd = {
        "roslyn-language-server",
        "--autoLoadProjects",
        "--stdio",
    },
    filetypes = { "cs" },
    root_dir = function(bufnr, cb)
        local root = vim.fs.root(bufnr, function(name)
            return name:match("%.sln$") or name:match("%.csproj$")
        end)
        if root then cb(root) end
    end,
    handlers = {
        ["workspace/projectInitializationComplete"] = function()
            vim.notify("Roslyn project initialization complete", vim.log.levels.INFO)
        end,
    },
}
