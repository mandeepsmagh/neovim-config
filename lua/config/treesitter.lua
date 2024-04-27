local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

-- require 'nvim-treesitter.install'.compilers = {'clang'}

configs.setup {
    ensure_installed = { 
        "lua", "c_sharp", "html", "typescript", "bash", "json", "svelte", "rust", "javascript", "c_sharp", "gitignore", "sql", "markdown", "markdown_inline"},
    sync_install = false,
    ignore_install = {},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    autopairs = {
        enable = true
    },
    incremental_selection = {
        enable = true
    },
    indent = {
        enable = false
    },
    rainbow = {
        enable = true,
        disable = {"html"},
        extended_mode = false,
        max_file_lines = nil
    },
    autotag = {
        enable = true
    }
}
