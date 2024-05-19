local opts = {
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true
            },
            checkOnSave = {
                command = "clippy"
            },
            experimental = {
                procAttrMacros = true
            },
            inlayHints = {
                enable = true,
                showParameterNames = true,
                parameterHintsPrefix = "<- ",
                otherHintsPrefix = "=> ",
            },
        }
    }
}

return opts
