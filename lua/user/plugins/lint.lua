return {
    'mfussenegger/nvim-lint',
    event = { 'BufWritePost' },
    opts = {
        linters_by_ft = {
            yaml = { 'yamllint', }
        },
    },
    config = function(_, opts)
        require('lint').linters_by_ft = opts.linters_by_ft
    end
}
