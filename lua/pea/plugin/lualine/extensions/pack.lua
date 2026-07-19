local colors = require "pea.plugin.lualine.colors"
local components = require "pea.plugin.lualine.components"

local status = {
    function()
        local plugins = vim.pack.get(nil, { info = false })
        local active_plugins = vim.iter(plugins)
            :filter(function(p)
                return p.active
            end)
            :totable()

        return #active_plugins .. "/" .. #plugins .. " loaded"
    end,
    color = { fg = colors.fg },
}

return {
    filetypes = { "nvim-pack" },
    sections = {
        lualine_c = {
            components.leftbar,
            components.evil,
            components.filetype,
            components.location,
            components.center,
            components.lsp,
            status,
        },
        lualine_x = {
            components.os,
            components.encoding,
            components.scrollbar,
        },
    },
}
