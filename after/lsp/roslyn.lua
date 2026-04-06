--
-- Roslyn Language Server for C#
-- Install: dotnet tool install --global roslyn-language-server --prerelease
-- Docs:    https://github.com/dotnet/roslyn/blob/main/src/LanguageServer/Microsoft.CodeAnalysis.LanguageServer/README.md
--
-- CMD OPTIONS (all optional, subject to change):
--   --stdio                        Use stdin/stdout for communication (default: false)
--   --pipe <name>                  Use named pipe for communication
--   --autoLoadProjects             Auto-discover projects from workspace folders (default: false)
--   --logLevel <level>             Trace|Debug|Information|Warning|Error|None (default: Information)
--   --extensionLogDirectory <path> Directory for log files
--   --extension <path>             Load extension assemblies, e.g. for Razor support
--   --debug                        Launch debugger on startup (default: false)
--   --telemetryLevel <level>       all|crash|error|off (default: off)

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
