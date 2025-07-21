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

            -- UI Setup
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            -- Signs
            local signs = {
                DapBreakpoint = { text = "⦿", texthl = "DiagnosticSignError" },
                DapBreakpointCondition = { text = "◉", texthl = "DiagnosticSignWarn" },
                DapLogPoint = { text = "⧉", texthl = "DiagnosticSignInfo" },
                DapStopped = {
                    text = "▶",
                    texthl = "DiagnosticSignHint",
                    linehl = "DapStoppedLine"
                },
            }
            for name, sign in pairs(signs) do
                vim.fn.sign_define(name, sign)
            end

            -- Debugger resolver
            local function find_debugger(global_cmd, mason_path)
                if vim.fn.executable(global_cmd) == 1 then
                    return vim.fn.exepath(global_cmd)
                elseif vim.fn.filereadable(mason_path) == 1 then
                    return mason_path
                else
                    return nil
                end
            end

            -- Rust (CodeLLDB)
            local codelldb = find_debugger(
                "codelldb",
                vim.fn.stdpath("data") .. "/mason/bin/codelldb"
            )

            if codelldb then
                dap.adapters.codelldb = {
                    type = "server",
                    port = "${port}",
                    executable = {
                        command = codelldb,
                        args = { "--port", "${port}" }
                    },
                }

                dap.configurations.rust = {
                    {
                        name = "Launch",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            local cwd = vim.fn.getcwd()
                            local debug_path = cwd .. "/target/debug"
                            local files = vim.fn.glob(debug_path .. "/*", false, true)
                            for _, file in ipairs(files) do
                                local name = vim.fn.fnamemodify(file, ":t")
                                if vim.fn.isdirectory(file) == 0 and not name:match("%.d$") and vim.fn.executable(file) == 1 then
                                    return file
                                end
                            end
                            return vim.fn.input("Executable: ", debug_path .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        name = "Attach",
                        type = "codelldb",
                        request = "attach",
                        pid = require("dap.utils").pick_process,
                    },
                }
            end

            -- C# (.NET Core)
            local netcoredbg = find_debugger(
                "netcoredbg",
                vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
            )

            if netcoredbg then
                dap.adapters.coreclr = {
                    type = "executable",
                    command = netcoredbg,
                    args = { "--interpreter=vscode" },
                }

                dap.configurations.cs = {
                    {
                        name = "Launch",
                        type = "coreclr",
                        request = "launch",
                        program = function()
                            local patterns = {
                                "/bin/Debug/**/*.dll",
                                "/bin/debug/**/*.dll",
                                "/bin/Release/**/*.dll",
                                "/bin/release/**/*.dll",
                            }
                            local found = {}
                            for _, pat in ipairs(patterns) do
                                local matches = vim.fn.glob(vim.fn.getcwd() .. pat, false, true)
                                for _, dll in ipairs(matches) do
                                    table.insert(found, dll)
                                end
                            end
                            table.sort(found, function(a, b)
                                return vim.fn.getftime(a) > vim.fn.getftime(b)
                            end)
                            return #found > 0 and found[1]
                                or vim.fn.input("DLL: ", vim.fn.getcwd() .. "/bin/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        name = "Attach",
                        type = "coreclr",
                        request = "attach",
                        processId = require("dap.utils").pick_process,
                    },
                }
            end
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "nvim-dap" },
        event = "VeryLazy",
        opts = {},
    },
}
