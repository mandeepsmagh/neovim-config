-- npm i -g vscode-langservers-extracted
return {
    cmd = { "vscode-eslint-language-server", " --stdio " },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" }
}
