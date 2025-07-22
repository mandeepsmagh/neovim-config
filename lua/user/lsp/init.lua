local servers = {
    "lua_ls",
    "rust_analyzer",
    "ts_ls",
    "jsonls",
    "bashls",
    "html",
    "cssls",
    "omnisharp",
}

for _, server in ipairs(servers) do
    local config = require("user.lsp." .. server)

    -- Inject default capabilities if missing
    config.capabilities = config.capabilities or require("blink.cmp").get_lsp_capabilities()

    -- Inject shared on_attach if missing
    config.on_attach = config.on_attach or function(client, bufnr)
        print("LSP attached to buffer for " .. vim.bo[bufnr].filetype)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end

    vim.lsp.config(server, config)
end

vim.lsp.enable(servers)

-- Diagnostics configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "if_many",
    },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.api.nvim_create_user_command("LspInfo", function()
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        print("No LSP clients attached")
    else
        for _, client in pairs(clients) do
            print(string.format("Client: %s (id: %d)", client.name, client.id))
        end
    end
end, {})
