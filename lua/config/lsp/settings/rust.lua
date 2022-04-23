local status_ok, nvim_lsp = pcall(require, "lspconfig")

if not status_ok then
    return
end

return {
    cmd =  { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir =  nvim_lsp.util.root_pattern("Cargo.toml", "rust-project.json"),
    settings = {
        ["rust-analyzer"] = {}
    }
}
