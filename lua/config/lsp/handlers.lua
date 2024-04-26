local M = {}

M.setup = function()
    local signs = { {
        name = "DiagnosticSignError",
        text = "⚠"
    }, {
        name = "DiagnosticSignWarn",
        text = "⚠"
    }, {
        name = "DiagnosticSignHint",
        text = "!"
    }, {
        name = "DiagnosticSignInfo",
        text = "!"
    }, {
    } }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
            texthl = sign.name,
            text = sign.text,
            numhl = ""
        })
    end

    local config = {
        -- disable virtual text
        virtual_text = false,
        -- show signs
        signs = {
            active = signs
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = ""
        }
    }
    -- Toggle function
    function _G.toggle_virtual_text()
      config.virtual_text = not config.virtual_text
      vim.diagnostic.config(config)
    end

    -- Key mapping
    vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>lua toggle_virtual_text()<CR>', {noremap = true, silent = true})
    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded"
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded"
    })
end

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    -- if client.server_capabilities.document_highlight then
    -- end
    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        return
    end
    illuminate.on_attach(client)
end

local function lsp_keymaps(bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]]
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

M.on_attach = function(client, bufnr)
    if client.name == "tsserver" or "sumneko_lua" then
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
    end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
