return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            "mfussenegger/nvim-dap-python",
        },
        cmd = { "DapToggleBreakpoint", "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Simplified DAPUI setup
            dapui.setup({
                controls = {
                    enabled = true,
                    element = "repl",
                },
                floating = {
                    border = "rounded",
                    mappings = { close = { "q", "<Esc>" } }
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes",      size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks",      size = 0.25 },
                            { id = "watches",     size = 0.25 }
                        },
                        position = "left",
                        size = 40
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 }
                        },
                        position = "bottom",
                        size = 10
                    }
                },
            })

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

            -- Language configurations
            require('dap-python').setup('python3')

            -- Python configuration
            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch Python Program',
                    program = "${file}",
                    pythonPath = function()
                        return vim.fn.exepath('python3')
                    end,
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch Python with Arguments',
                    program = "${file}",
                    args = function()
                        local args_string = vim.fn.input('Arguments: ')
                        return vim.split(args_string, " +")
                    end,
                    pythonPath = function()
                        return vim.fn.exepath('python3')
                    end,
                },
            }

            -- JavaScript/TypeScript Configuration (requires js-debug-adapter)
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                        "${port}"
                    },
                }
            }

            for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                        sourceMaps = true,
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require 'dap.utils'.pick_process,
                        cwd = "${workspaceFolder}",
                    }
                }
            end

            -- Rust Configuration
            dap.adapters.lldb = {
                type = 'executable',
                command = vim.fn.exepath('lldb-vscode') or vim.fn.exepath('lldb'),
                name = "lldb"
            }

            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                },
            }

            -- .NET Configuration
            dap.adapters.coreclr = {
                type = 'executable',
                command = vim.fn.stdpath("data") .. '/mason/packages/netcoredbg/netcoredbg',
                args = { '--interpreter=vscode' }
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "Launch",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                },
            }
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "nvim-dap" },
        event = "LspAttach",
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = true,
                show_stop_reason = true,
                commented = false,
                virt_text_pos = 'eol',
                all_frames = false,
                virt_lines = false,
                virt_text_win_col = nil
            })
        end
    },

    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-dap" },
        config = function()
            require('telescope').load_extension('dap')
        end
    },
}
