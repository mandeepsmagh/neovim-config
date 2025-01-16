local M = {}

function M.CreateNote()
    local timestamp = os.date("%Y%m%d%H%M%S")
    local location = vim.fn.input("Enter file location: ")
    local title = vim.fn.input("Enter note title: ")
    local filename = location .. "/" .. timestamp .. "-" .. title .. ".md"
    vim.cmd("edit " .. filename)

    -- Determine the template file path based on the operating system
    local template_path
    if vim.fn.has("win32") == 1 then
        template_path = "~/AppData/Local/nvim/lua/user/templates/notes-template.md"
    else
        template_path = "~/.config/nvim/lua/user/templates/notes-template.md"
    end

    vim.cmd("0r " .. template_path)
    vim.fn.setline(1, { "---", "id: " .. timestamp, "title: " .. title, "keywords: ", "---", "# " .. title })
    vim.cmd("write")
end

return M
