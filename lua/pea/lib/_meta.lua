---@meta
error "Cannot require a meta file"

---@alias Lib.Autocmd
--- | [vim.api.keyset.events|vim.api.keyset.events[], string|integer?, vim.api.keyset.create_autocmd, fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?]
--- | [vim.api.keyset.events|vim.api.keyset.events[], string|integer?, fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?]

---@alias Lib.Keymap [string|string[], string|string[], function|string, vim.keymap.set.Opts?]
