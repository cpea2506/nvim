vim.pack.add { "https://github.com/cpea2506/one_monokai.nvim" }

require("one_monokai").setup {
    transparent = true,
    highlights = function(colors)
        return {
            DapBreakpoint = { fg = colors.dark_red, ctermbg = 0 },
            DapLogPoint = { fg = colors.aqua, ctermbg = 0 },
            DapStopped = { fg = colors.green, ctermbg = 0 },

            BlinkCmpLabelMatch = { bold = true },
        }
    end,
}
