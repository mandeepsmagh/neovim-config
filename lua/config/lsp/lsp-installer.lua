local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = require("config.lsp.handlers").on_attach,
        capabilities = require("config.lsp.handlers").capabilities,
    }
    -- Override server settings if present
    local present, server_settings = pcall(require, "config.lsp.settings." .. server.name)
    if present then
      opts = vim.tbl_deep_extend("force", server_settings, opts)
    end
	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)
