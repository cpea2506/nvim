return {
    "stevearc/quicker.nvim",
    ft = "qf",
    opts = function()
        local icons = require "pea.ui.icons"

        return {
            type_icons = {
                E = icons.diagnostics.ERROR,
                W = icons.diagnostics.WARN,
                I = icons.diagnostics.INFO,
                H = icons.diagnostics.HINT,
            },
        }
    end,
}
