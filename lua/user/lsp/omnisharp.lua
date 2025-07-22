local sysname = vim.loop.os_uname().sysname
local dotnet_root = os.getenv("DOTNET_ROOT")

if not dotnet_root then
    if sysname == "Darwin" then
        dotnet_root = "/usr/local/share/dotnet"
    elseif sysname == "Linux" then
        dotnet_root = "/usr/share/dotnet"
    elseif sysname == "Windows_NT" then
        dotnet_root = "C:\\Program Files\\dotnet"
    end
end

vim.env.DOTNET_ROOT = dotnet_root

return {
    cmd = { "omnisharp" },
    filetypes = { "cs" },
    root_markers = { "*.sln", "*.csproj", ".git" },
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
        },
    },
    handlers = {
        ["textDocument/definition"] = function(...)
            return require("omnisharp_extended").handler(...)
        end,
    },
    on_new_config = function(new_config)
        new_config.cmd_env = { DOTNET_ROOT = dotnet_root }
    end,
}
