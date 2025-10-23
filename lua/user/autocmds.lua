-- Autocommand groups
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
    group = general,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
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
local lsp_group = augroup("LspAttach", { clear = true })
local no_format = { sql = true }

-- LSP keymaps when buffer has LSP
autocmd("LspAttach", {
    group = lsp_group,
    callback = function(event)
        -- Format on save
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local ft = vim.bo[event.buf].filetype

        if no_format[ft] then
            if client then
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end
            return
        end
        if client and client.server_capabilities.documentFormattingProvider then
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

-- Inlay hints toggle
autocmd("LspAttach", {
    group = lsp_group,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
            vim.keymap.set("n", "<leader>th", function()
                local bufnr = event.buf
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, { buffer = event.buf, desc = "Toggle inlay hints" })
        end
    end,
})

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

vim.api.nvim_create_user_command("LspDebug", function()
    local ft = vim.bo.filetype
    local root = vim.fs.find({ "*.sln", "*.csproj", ".git" }, { upward = true })[1]
    print("Filetype:", ft)
    print("Project root:", root or "No root found")
    print("Clients:", vim.inspect(vim.lsp.get_clients()))
end, {})
