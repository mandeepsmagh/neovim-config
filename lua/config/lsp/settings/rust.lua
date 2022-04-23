local nvim_lsp = require'nvim_lsp'

return {
    cmd =  { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir =  nvim_lsp.util.root_pattern("Cargo.toml", "rust-project.json"),
    settings = {
        ["rust-analyzer"] = {}
    }
}
