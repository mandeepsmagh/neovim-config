local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

-- require 'nvim-treesitter.install'.compilers = {'clang'}

configs.setup {
    ensure_installed = { "lua", "rust", "javascript", "c_sharp", "pug", "java"  },
    sync_install = false,
    ignore_install = {},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false
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
