local M = {}

local on = require("vim._core.util").nvim_on

---List of icons.
M.icons = require "pea.lib.icons"

---Whether current OS is Windows.
M.is_windows = jit.os:find "Windows" ~= nil

---@class Autocmd
---@field [1] vim.api.keyset.events|vim.api.keyset.events[]
---@field [2] string|integer?
---@field [3] vim.api.keyset.create_autocmd|fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?
---@field [4]? fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?

---Create autocmds.
---@param autocmds Autocmd[] #List of autocmds.
function M.create_autocmds(autocmds)
    for _, autocmd in ipairs(autocmds) do
        local events, group, opts_or_fn, fn = unpack(autocmd)

        on(events, group, opts_or_fn, fn)
    end
end

---@class Keymap
---@field [1] string|string[]
---@field [2] string
---@field [3] string|function
---@field [4]? vim.keymap.set.Opts

---Set keymaps.
---@param keymaps Keymap[] #List of keymaps.
function M.set_keymaps(keymaps)
    for _, keymap in ipairs(keymaps) do
        local modes, lhs, rhs, opts = unpack(keymap)
        opts = vim.tbl_extend("force", { silent = true }, opts or {})

        vim.keymap.set(modes, lhs, rhs, opts)
    end
end

---Load modules.
---@param root string #Root module.
---@param modules string[] #List of modules.
function M.load_modules(root, modules)
    local loaded = {}

    for _, module in ipairs(modules) do
        table.insert(loaded, require(("%s.%s"):format(root, module)))
    end

    return loaded
end

return M
