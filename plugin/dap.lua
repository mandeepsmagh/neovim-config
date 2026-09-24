local once = require("once")

local setup = once(function()
    vim.pack.add({
        { src = "https://github.com/mfussenegger/nvim-dap" },
        { src = "https://github.com/rcarriga/nvim-dap-ui" },
        { src = "https://github.com/nvim-neotest/nvim-nio" },
        { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    })

    local dap = require("dap")
    local dapui = require("dapui")

    require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
    })

    dapui.setup({})

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    local signs = {
        DapBreakpoint = {
            text = "?",
            texthl = "DiagnosticSignError",
        },
        DapBreakpointCondition = {
            text = "?",
            texthl = "DiagnosticSignWarn",
        },
        DapLogPoint = {
            text = "?",
            texthl = "DiagnosticSignInfo",
        },
        DapStopped = {
            text = "",
            texthl = "DiagnosticSignHint",
            linehl = "DapStoppedLine",
        },
    }

    for name, sign in pairs(signs) do
        vim.fn.sign_define(name, sign)
    end

    local function find_debugger(global_cmd, mason_path)
        if vim.fn.executable(global_cmd) == 1 then
            return vim.fn.exepath(global_cmd)
        elseif vim.fn.filereadable(mason_path) == 1 then
            return mason_path
        end

        return nil
    end

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
                args = { "--port", "${port}" },
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

                        if vim.fn.isdirectory(file) == 0
                            and not name:match("%.d$")
                            and vim.fn.executable(file) == 1
                        then
                            return file
                        end
                    end

                    return vim.fn.input(
                        "Executable: ",
                        debug_path .. "/",
                        "file"
                    )
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

                    for _, pattern in ipairs(patterns) do
                        local matches = vim.fn.glob(
                            vim.fn.getcwd() .. pattern,
                            false,
                            true
                        )

                        vim.list_extend(found, matches)
                    end

                    table.sort(found, function(a, b)
                        return vim.fn.getftime(a) > vim.fn.getftime(b)
                    end)

                    return #found > 0
                        and found[1]
                        or vim.fn.input(
                            "DLL: ",
                            vim.fn.getcwd() .. "/bin/",
                            "file"
                        )
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

    return dap
end)

local map = vim.keymap.set

map("n", "<F5>", function() setup().continue() end, { desc = "Debug: Continue" })

map("n", "<F10>", function() setup().step_over() end, { desc = "Debug: Step Over" })

map("n", "<F11>", function() setup().step_into() end, { desc = "Debug: Step Into" })

map("n", "<F9>", function() setup().step_out() end, { desc = "Debug: Step Out" })

map("n", "<leader>b", function() setup().toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })

map("n", "<leader>dB", function() setup().clear_breakpoints() end, { desc = "Debug: Clear All Breakpoints" })

map("n", "<leader>B", function()
    setup().set_breakpoint(
        nil,
        nil,
        vim.fn.input("Breakpoint condition: ")
    )
end, { desc = "Debug: Conditional Breakpoint" })

map("n", "<leader>lp", function()
    setup().set_breakpoint(
        nil,
        nil,
        vim.fn.input("Log point message: ")
    )
end, { desc = "Debug: Log Point" })

map({ "n", "v" }, "<leader>de", function()
    setup()
    require("dapui").eval()
end, { desc = "Debug: Evaluate" })

map("n", "<leader>du", function()
    setup()
    require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })

map("n", "<leader>dc", function()
    setup()
    require("dapui").toggle({ layout = 2 })
end, { desc = "DAP Output (toggle bottom)" })

map("n", "<leader>dr", function() setup().repl.open() end, { desc = "Debug: REPL" })
