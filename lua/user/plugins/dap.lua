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
        keys = {
            { "<F5>",       function() require("dap").continue() end,                                                    desc = "Debug: Continue" },
            { "<F10>",      function() require("dap").step_over() end,                                                   desc = "Debug: Step Over" },
            { "<F11>",      function() require("dap").step_into() end,                                                   desc = "Debug: Step Into" },
            { "<F9>",       function() require("dap").step_out() end,                                                    desc = "Debug: Step Out" },
            { "<leader>b",  function() require("dap").toggle_breakpoint() end,                                           desc = "Debug: Toggle Breakpoint" },
            { "<leader>dr", function() require("dapui").toggle() end,                                                    desc = "Debug: Toggle UI" },
            { "<leader>B",  function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,        desc = "Debug: Conditional Breakpoint" },
            { "<leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Debug: Log Point" }
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Complete DAP UI setup with all required fields
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

            -- Auto open/close dapui
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Enhanced signs
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

            -- Python setup
            require('dap-python').setup('python3')

            -- Enhanced Python configurations
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
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-dap", "nvim-neotest/nvim-nio" },
        keys = {
            { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
            { "<leader>de", function() require("dapui").eval() end,   mode = { "n", "v" },      desc = "Debug: Evaluate" },
        },
        config = false, -- Configuration is handled in nvim-dap
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
        keys = {
            { "<leader>ds", function() require('telescope').extensions.dap.configurations() end,   desc = "Debug: Configurations" },
            { "<leader>db", function() require('telescope').extensions.dap.list_breakpoints() end, desc = "Debug: Breakpoints" },
        },
        config = function()
            require('telescope').load_extension('dap')
        end
    },
}
