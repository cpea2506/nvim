vim.pack.add { "https://github.com/nvim-lualine/lualine.nvim" }

local colors = require "pea.plugin.lualine.colors"
local components = require "pea.plugin.lualine.components"

require("lualine").setup {
    options = {
        theme = {
            normal = {
                c = { fg = colors.fg, bg = colors.bg },
            },
            inactive = {
                c = { fg = colors.fg, bg = colors.bg },
            },
        },
        disabled_filetypes = {
            "",
            "checkhealth",
            "fyler_finder",
            "fzf",
            "gitsigns-blame",
            "help",
            "input",
            "mason",
            "pager",
            "select",
        },
        globalstatus = true,
        component_separators = "",
        section_separators = "",
    },
    extensions = lib.require_modules("pea.plugin.lualine.extensions", { "pack", "quickfix" }),
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {
            components.leftbar,
            components.evil,
            components.filesize,
            components.filetype,
            components.location,
            components.diagnostics,
            components.macro,
            components.debug,
            components.center,
            components.lsp,
        },
        lualine_x = {
            components.treesitter,
            components.os,
            components.encoding,
            components.branch,
            components.scrollbar,
        },
    },
    inactive_sections = {
        lualine_a = {
            "filename",
        },
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}
