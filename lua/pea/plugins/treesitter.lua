return {
    {
        "arborist-ts/arborist.nvim",
        build = ":ArboristUpdate",
        event = "LazyFile",
        dependencies = "nvim-treesitter/nvim-treesitter-context",
        opts = {},
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            mode = "cursor",
            max_lines = 3,
        },
        keys = {
            {
                "[c",
                function()
                    require("treesitter-context").go_to_context(vim.v.count1)
                end,
                desc = "Go To Context",
            },
        },
    },
}
