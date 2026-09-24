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

-- Remove trailing whitespace on save. Filetypes that need it (Markdown
-- hard breaks) opt out by setting b:trim_trailing_whitespace = false in
-- their ftplugin.
autocmd("BufWritePre", {
    group = general,
    callback = function()
        if vim.bo.buftype ~= "" then return end
        if vim.b.trim_trailing_whitespace == false then return end
        local view = vim.fn.winsaveview()
        vim.cmd([[silent! keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
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

-- Auto-reload buffers when files change on disk.
-- CursorHoldI is intentionally excluded: checktime can pop a blocking
-- W12 warning, and triggering that mid-insert is jarring.
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
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
            -- Buffer-scoped group with clear = true: if multiple clients
            -- attach to the same buffer, each LspAttach replaces this
            -- buffer's format autocmd instead of stacking another one,
            -- so BufWritePre only formats once per save.
            local fmt_group = augroup("LspFormat_" .. event.buf, { clear = true })
            autocmd("BufWritePre", {
                group = fmt_group,
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
        table.insert(lines, string.format("- %s (id=%d)  root=%s", client.name, client.id, client.root_dir or "nil"))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "LSP" })
end, { desc = "Show LSP clients attached to current buffer" })
