local M = {}

--- Return template lines without its front matter and first heading,
--- since the note supplies its own.
--- @param path string
--- @return string[]
local function template_body(path)
    local lines = vim.fn.readfile(path)
    local i = 1

    if lines[1] == "---" then
        for j = 2, #lines do
            if lines[j] == "---" then
                i = j + 1
                break
            end
        end
    end

    while lines[i] == "" do i = i + 1 end
    if lines[i] and lines[i]:match("^# ") then i = i + 1 end

    return vim.list_slice(lines, i)
end

function M.CreateNote()
    local timestamp = os.date("%Y%m%d%H%M%S")
    local default = vim.fn.getcwd()
    local location = vim.fn.input("Enter file location: ", default, "dir")

    if location == "" then
        vim.notify("No file location provided. Aborting note creation.", vim.log.levels.WARN)
        return
    end

    local title = vim.fn.input("Enter note title: ")
    if title == "" then
        vim.notify("No title provided. Aborting note creation.", vim.log.levels.WARN)
        return
    end

    local filename = vim.fs.joinpath(vim.fn.expand(location), timestamp .. "-" .. title .. ".md")
    vim.cmd("edit " .. vim.fn.fnameescape(filename))

    -- Template lives in the config directory (repo root via symlink)
    local template_path = vim.fn.stdpath("config") .. "/lua/user/templates/notes-template.md"

    local lines = { "---", "id: " .. timestamp, "title: " .. title, "keywords: ", "---", "# " .. title }
    vim.list_extend(lines, template_body(template_path))

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.cmd("write")
end

return M
