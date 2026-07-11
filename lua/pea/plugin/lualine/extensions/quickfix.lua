local colors = require "pea.plugin.lualine.colors"
local components = require "pea.plugin.lualine.components"

local label = {
    function()
        local loclist = vim.fn.getloclist(0, { title = 0 })
        local qflist = vim.fn.getqflist { title = 0 }
        local is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0

        return is_loclist and "Location: " .. loclist.title or "Quickfix: " .. qflist.title
    end,
    color = { fg = colors.jungle_green },
}

return {
    init = function()
        vim.g.qf_disable_statusline = true
    end,
    filetypes = { "qf" },
    sections = {
        lualine_c = {
            components.leftbar,
            components.evil,
            components.location,
            components.center,
            label,
        },
        lualine_x = {
            components.scrollbar,
        },
    },
}
