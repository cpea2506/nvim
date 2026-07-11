vim.pack.add { "https://github.com/cpea2506/one_monokai.nvim" }

require("one_monokai").setup {
    transparent = true,
    highlights = function(colors)
        return {
            ["@lsp.type.event.cs"] = { fg = colors.yellow },
            ["@lsp.type.delegate.cs"] = { link = "@function" },
            ["@lsp.type.keyword.cs"] = { fg = colors.pink },
            ["@lsp.type.constant.cs"] = { link = "@constant" },
            ["@lsp.type.interface.cs"] = { link = "@type" },

            BlinkCmpLabelMatch = { bold = true },

            DapBreakpoint = { fg = colors.dark_red, ctermbg = 0 },
            DapLogPoint = { fg = colors.aqua, ctermbg = 0 },
            DapStopped = { fg = colors.green, ctermbg = 0 },
        }
    end,
}
