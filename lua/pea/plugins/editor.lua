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
        opts = {
            type_icons = {
                E = lib.icons.diagnostics.ERROR,
                W = lib.icons.diagnostics.WARN,
                I = lib.icons.diagnostics.INFO,
                H = lib.icons.diagnostics.HINT,
            },
        },
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
