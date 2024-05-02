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
    },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["at"] = "@class.outer",
          ["it"] = "@class.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@call.outer",
          ["ic"] = "@call.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",
          ["a/"] = "@comment.outer",
          ["i/"] = "@comment.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["as"] = "@statement.outer",
          ["is"] = "@scopename.inner",
          ["aA"] = "@attribute.outer",
          ["iA"] = "@attribute.inner",
          ["aF"] = "@frame.outer",
          ["iF"] = "@frame.inner",
        },
      },
    },
}
