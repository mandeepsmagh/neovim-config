local M = {}

local status_ok, loader = pcall(require, "luasnip/loaders/from_vscode")
  if status_ok then
    loader.lazy_load()
  end

return M
