local M = {}

---List of icons.
M.icons = require "pea.lib.icons"

---Whether current OS is Windows.
M.is_windows = jit.os:find "Windows" ~= nil

M.create_autocmd = require("vim._core.util").nvim_on

---Create autocmds.
---@param autocmds Lib.Autocmd[] #List of autocmds.
function M.create_autocmds(autocmds)
    for _, autocmd in ipairs(autocmds) do
        local events, group, opts_or_fn, fn = unpack(autocmd)

        if type(opts_or_fn) == "function" then
            M.create_autocmd(events, group, opts_or_fn)
        else
            M.create_autocmd(events, group, opts_or_fn, fn)
        end
    end
end

M.set_keymap = vim.keymap.set

---Set keymaps.
---@param keymaps Lib.Keymap[] #List of keymaps.
function M.set_keymaps(keymaps)
    for _, keymap in ipairs(keymaps) do
        local modes, lhs, rhs, opts = unpack(keymap)
        opts = vim.tbl_extend("force", { silent = true }, opts or {})

        M.set_keymap(modes, lhs, rhs, opts)
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
