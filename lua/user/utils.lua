local M = {}

function M.CreateNote()
    local timestamp = os.date("%Y%m%d%H%M%S")
    local location = vim.fn.input("Enter file location: ")

    -- Check if location is empty or nil
    if location == nil or location == "" then
        print("Error: No file location provided. Aborting note creation.")
        return
    end

    local title = vim.fn.input("Enter note title: ")
    if title == nil or title == "" then
        print("Error: No title provided. Aborting note creation.")
        return
    end

    local filename = location .. "/" .. timestamp .. "-" .. title .. ".md"
    vim.cmd("edit " .. vim.fn.fnameescape(filename))

    -- Template lives in the config directory (repo root via symlink)
    local template_path = vim.fn.stdpath("config") .. "/lua/user/templates/notes-template.md"

    vim.cmd("0r " .. vim.fn.fnameescape(template_path))
    vim.fn.setline(1, { "---", "id: " .. timestamp, "title: " .. title, "keywords: ", "---", "# " .. title })
    vim.cmd("write")
end

return M
