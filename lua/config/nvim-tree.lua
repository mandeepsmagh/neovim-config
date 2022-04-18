local g = vim.g      -- a table to access global variables
-------------------------------NVIM-Tree-Options---------------------------
g.nvim_tree_width = 30
g.nvim_tree_ignore = {'.git', 'node_modules', '.cache'}
g.nvim_tree_gitignore = 1
g.nvim_tree_auto_open = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_width_allow_resize  = 1
g.nvim_tree_special_files = {'README.md', 'Makefile', 'MAKEFILE'}
g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1
}
g.nvim_tree_icons = {
    default = "‣ ",
    symlink = " ",
    git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★"
    },
    folder = {
            default = "",
            open = "",
            symlink = ""
    }
}
