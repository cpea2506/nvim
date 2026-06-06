local lazy = vim.npcall(require, "lazy")

if not lazy then
    return {}
end

local colors = require "pea.plugins.lualine.colors"
local components = require "pea.plugins.lualine.components"

local title = {
    function()
        return "💤 Lazy:"
    end,
    padding = { right = 0 },
    color = { fg = colors.blue },
}

local status = {
    function()
        return lazy.stats().loaded .. "/" .. lazy.stats().count .. " loaded"
    end,
    color = { fg = colors.fg },
}

return {
    filetypes = { "lazy" },
    sections = {
        lualine_c = {
            components.leftbar,
            components.evil,
            components.center,
            title,
            status,
        },
        lualine_x = {
            components.scrollbar,
        },
    },
}
