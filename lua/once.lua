local M = {}

--- Wrap a function so it runs at most once, no matter how many times
--- or from how many trigger points it's called.
--- @param fn function
--- @return function
local function once(fn)
    local done = false
    local result

    return function(...)
        if not done then
            done = true
            result = fn(...)
        end

        return result
    end
end

--- Run fn the first time any of events fires, then never again.
--- @param events string|string[]
--- @param fn function
function M.event(events, fn)
    vim.api.nvim_create_autocmd(events, {
        once = true,
        callback = fn,
    })
end

--- Run fn whenever a buffer with a matching filetype is opened.
--- The function can be wrapped with once() to initialize only once.
--- @param fts string|string[]
--- @param fn function
function M.filetype(fts, fn)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = fts,
        callback = fn,
    })
end

--- Define placeholder commands that load the implementation on first use,
--- then re-execute the original command with its bang, range, register,
--- and arguments.
--- @param names string[]
--- @param setup_fn function
function M.cmd(names, setup_fn)
    for _, name in ipairs(names) do
        vim.api.nvim_create_user_command(name, function(opts)
            vim.api.nvim_del_user_command(name)
            setup_fn()

            if vim.fn.exists(":" .. name) == 0 then
                vim.notify(
                    ("once.cmd: '%s' was not defined after setup"):format(name),
                    vim.log.levels.WARN
                )
                return
            end

            local range = opts.range == 2 and (opts.line1 .. "," .. opts.line2)
                or opts.range == 1 and tostring(opts.line1)
                or ""

            local bang = opts.bang and "!" or ""
            local reg = opts.reg ~= "" and ('"' .. opts.reg) or ""

            vim.cmd(("%s%s%s%s %s"):format(
                range,
                name,
                bang,
                reg,
                opts.args
            ))
        end, {
            nargs = "*",
            bang = true,
            range = true,
            register = true,
        })
    end
end

return setmetatable(M, {
    __call = function(_, fn)
        return once(fn)
    end,
})
