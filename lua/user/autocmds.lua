-- Autocommand groups
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
    group = general,
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
    group = general,
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})

-- Resize splits if window got resized
autocmd("VimResized", {
    group = general,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
    group = general,
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Configure native commenting for specific filetypes
autocmd("FileType", {
    group = general,
    pattern = { "lua", "vim" },
    callback = function()
        vim.bo.commentstring = "-- %s"
    end,
})

autocmd("FileType", {
    group = general,
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "css", "scss" },
    callback = function()
        vim.bo.commentstring = "// %s"
    end,
})

-- Auto-reload buffers when files change on disk
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = general,
    desc = "Check if files changed on disk",
    pattern = "*",
    command = "checktime",
})

-- LSP settings
local lsp_group = augroup("LspGroup", { clear = true })
local no_format = { sql = true }

autocmd("LspAttach", {
    group = lsp_group,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end
        local ft = vim.bo[event.buf].filetype

        -- Inlay hints: enable by default + toggle keymap
        if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            vim.keymap.set("n", "<leader>th", function()
                vim.lsp.inlay_hint.enable(
                    not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
                    { bufnr = event.buf }
                )
            end, { buffer = event.buf, desc = "Toggle inlay hints" })
        end

        -- Format on save (skip filetypes in no_format)
        if no_format[ft] then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            return
        end

        if client:supports_method("textDocument/formatting") then
            autocmd("BufWritePre", {
                group = lsp_group,
                buffer = event.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = event.buf })
                end,
            })
        end
    end,
})

vim.api.nvim_create_user_command("LspInfo", function()
    local buf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = buf })
    if #clients == 0 then
        vim.notify("No LSP attached", vim.log.levels.WARN)
        return
    end
    local lines = { "ft=" .. vim.bo[buf].filetype }
    for _, client in ipairs(clients) do
        table.insert(lines, string.format("• %s (id=%d)  root=%s", client.name, client.id, client.root_dir or "nil"))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "LSP" })
end, { desc = "Show LSP clients attached to current buffer" })

-- Linting settings
local lint_group = augroup("Linting", { clear = true })

-- Lint on save
autocmd("BufWritePost", {
    group = lint_group,
    desc = "Run linters after file save",
    callback = function()
        local lint_status, lint = pcall(require, "lint")
        if lint_status then
            lint.try_lint()
        end
    end,
})
