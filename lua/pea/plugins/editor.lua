return {
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        opts = {
            default_mappings = false,
            mappings = {
                i = {
                    j = {
                        k = "<Esc>",
                    },
                },
            },
        },
    },
    {
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
    },
    {
        "cpea2506/select.nvim",
        event = "LazyFile",
    },
    {
        "cpea2506/input.nvim",
        event = "LazyFile",
    },
    {
        "kylechui/nvim-surround",
        event = "LazyFile",
        opts = {},
    },
    {
        "nacro90/numb.nvim",
        keys = ":",
        opts = {
            number_only = true,
        },
    },
    {
        "cpea2506/relative-toggle.nvim",
        event = "LazyFile",
    },
}
