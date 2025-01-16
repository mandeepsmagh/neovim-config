return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        config = function()
            local dap_status_ok, dap = pcall(require, "dap")
            if not dap_status_ok then
                return
            end

            local dap_ui_status_ok, dapui = pcall(require, "dapui")
            if not dap_ui_status_ok then
                return
            end

            dapui.setup {
                icons = { expanded = "▾", collapsed = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            -- { id = "stacks", size = 0.25 },
                            -- { id = "watches", size = 0.25 },
                        },
                        size = 40,
                        position = "right",
                    },
                },
                floating = {
                    max_height = nil,
                    max_width = nil,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
            }

            vim.fn.sign_define('DapBreakpoint', {text="🔴", texthl='DiagnosticSignError', linehl='', numhl=''})

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        lazy = true,
    },
}
