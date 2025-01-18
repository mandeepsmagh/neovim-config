return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            -- Add language-specific adapters
            "microsoft/vscode-node-debug2", -- For TypeScript
            "mfussenegger/nvim-dap-python", -- For Python
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Common configurations for dap-ui
            dapui.setup({
                controls = {
                    element = "repl",
                    enabled = true,
                    icons = {
                        disconnect = "",
                        pause = "",
                        play = "",
                        run_last = "",
                        step_back = "",
                        step_into = "",
                        step_out = "",
                        step_over = "",
                        terminate = ""
                    }
                },
                element_mappings = {},
                expand_lines = true,
                floating = {
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" }
                    }
                },
                force_buffers = true,
                icons = {
                    collapsed = "",
                    current_frame = "",
                    expanded = ""
                },
                layouts = {
                    {
                        elements = {
                            {
                                id = "scopes",
                                size = 0.25
                            },
                            {
                                id = "breakpoints",
                                size = 0.25
                            },
                            {
                                id = "stacks",
                                size = 0.25
                            },
                            {
                                id = "watches",
                                size = 0.25
                            }
                        },
                        position = "left",
                        size = 40
                    },
                    {
                        elements = {
                            {
                                id = "repl",
                                size = 0.5
                            },
                            {
                                id = "console",
                                size = 0.5
                            }
                        },
                        position = "bottom",
                        size = 10
                    }
                },
                mappings = {
                    edit = "e",
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    repl = "r",
                    toggle = "t"
                },
                render = {
                    indent = 1,
                    max_value_lines = 100
                }
            })

            -- Automatically open/close dapui
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Add common configurations that work across LSPs
            dap.configurations.common = {
                {
                    type = "common",
                    request = "launch",
                    name = "Launch Program",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                }
            }

            -- Sign configurations
            vim.fn.sign_define('DapBreakpoint', {
                text = "⦿",
                texthl = 'DiagnosticSignError',
                linehl = '',
                numhl = ''
            })
            vim.fn.sign_define('DapBreakpointCondition', {
                text = "◉",
                texthl = 'DiagnosticSignWarn',
                linehl = '',
                numhl = ''
            })
            vim.fn.sign_define('DapLogPoint', {
                text = "⧉",
                texthl = 'DiagnosticSignInfo',
                linehl = '',
                numhl = ''
            })
            vim.fn.sign_define('DapStopped', {
                text = "▶",
                texthl = 'DiagnosticSignHint',
                linehl = 'DapStoppedLine',
                numhl = ''
            })
            -- Python Configuration
            require('dap-python').setup('python3')
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

            -- TypeScript/JavaScript Configuration
            dap.adapters.node2 = {
                type = 'executable',
                command = 'node',
                args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
            }

            dap.configurations.typescript = {
                {
                    type = "node2",
                    request = "launch",
                    name = "Launch TypeScript Program",
                    program = "${file}",
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                    protocol = "inspector",
                    outFiles = { "${workspaceFolder}/dist/**/*.js" },
                },
                {
                    type = "node2",
                    request = "attach",
                    name = "Attach to Process",
                    processId = require('dap.utils').pick_process,
                },
            }
            dap.configurations.javascript = dap.configurations.typescript

            -- Rust Configuration
            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb', -- adjust path as needed
                name = "lldb"
            }

            dap.configurations.rust = {
                {
                    name = "Launch Rust Program",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                    runInTerminal = false,
                },
                {
                    name = "Attach to Process",
                    type = "lldb",
                    request = "attach",
                    pid = require('dap.utils').pick_process,
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
                    name = "Launch .NET Core Program",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                },
                {
                    type = "coreclr",
                    name = "Attach to Process",
                    request = "attach",
                    processId = require('dap.utils').pick_process,
                },
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
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
        lazy = true,
        config = function()
            require('telescope').load_extension('dap')
        end
    },
}
