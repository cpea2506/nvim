local colors = require "pea.plugin.lualine.colors"
local components = require "pea.plugin.lualine.components"

local cwdtext = {
    function()
        return "CWD:"
    end,
    color = { fg = colors.jungle_green, gui = "bold" },
    padding = { right = 0 },
}

local cwd = {
    function()
        return vim.uv.cwd()
    end,
    color = { fg = colors.fg },
}

return {
    filetypes = { "directory" },
    sections = {
        lualine_c = {
            components.leftbar,
            components.evil,
            components.filetype,
            components.location,
            components.center,
            cwdtext,
            cwd,
        },
        lualine_x = {
            components.os,
            components.encoding,
            components.scrollbar,
        },
    },
}
