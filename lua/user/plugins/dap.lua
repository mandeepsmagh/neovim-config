return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
        },
        cmd = { "DapToggleBreakpoint", "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Basic setup with defaults
            dapui.setup()

            -- Auto open/close dapui
            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            -- Setup signs
            local signs = {
                DapBreakpoint = { text = "⦿", texthl = 'DiagnosticSignError' },
                DapBreakpointCondition = { text = "◉", texthl = 'DiagnosticSignWarn' },
                DapLogPoint = { text = "⧉", texthl = 'DiagnosticSignInfo' },
                DapStopped = { text = "▶", texthl = 'DiagnosticSignHint', linehl = 'DapStoppedLine' },
            }

            for name, sign in pairs(signs) do
                vim.fn.sign_define(name, sign)
            end

            -- Rust (codelldb via Mason)
            local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
            if vim.fn.has("win32") == 1 then codelldb = codelldb .. ".exe" end

            if vim.fn.filereadable(codelldb) == 1 then
                dap.adapters.codelldb = {
                    type = 'server',
                    port = "${port}",
                    executable = { command = codelldb, args = { "--port", "${port}" } }
                }

                dap.configurations.rust = {
                    {
                        name = "Launch",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            -- Find any executable in target/debug/ (excluding .d files and directories)
                            local executables = vim.fn.glob(vim.fn.getcwd() .. '/target/debug/*', false, true)
                            for _, exe in ipairs(executables) do
                                -- Skip .d files, directories, and files with extensions
                                if vim.fn.isdirectory(exe) == 0 and
                                    not exe:match('%.d$') and
                                    not exe:match('%.') and
                                    vim.fn.executable(exe) == 1 then
                                    return exe
                                end
                            end
                            return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                        end,
                        cwd = '${workspaceFolder}',
                    },
                    {
                        name = "Attach",
                        type = "codelldb",
                        request = "attach",
                        pid = require('dap.utils').pick_process,
                    },
                }
            end

            -- C# (netcoredbg via Mason)
            local netcoredbg = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
            if vim.fn.has("win32") == 1 then netcoredbg = netcoredbg .. ".exe" end

            if vim.fn.filereadable(netcoredbg) == 1 then
                dap.adapters.coreclr = {
                    type = 'executable',
                    command = netcoredbg,
                    args = { '--interpreter=vscode' }
                }

                dap.configurations.cs = {
                    {
                        name = "Launch",
                        type = "coreclr",
                        request = "launch",
                        program = function()
                            local dlls = vim.fn.glob(vim.fn.getcwd() .. '/bin/Debug/**/*.dll', false, true)
                            return #dlls > 0 and dlls[1]
                                or vim.fn.input('DLL: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                        end,
                        cwd = '${workspaceFolder}',
                    },
                    {
                        name = "Attach",
                        type = "coreclr",
                        request = "attach",
                        processId = require('dap.utils').pick_process,
                    },
                }
            end
        end,
    },

    -- Virtual text with minimal config
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "nvim-dap" },
        event = "VeryLazy",
        opts = {}
    },
}
