return {
    "FylerOrg/fyler.nvim",
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    opts = {
        integrations = {
            icon = "nvim_web_devicons",
        },
        kind = "floating",
        kind_presets = {
            floating = {
                border = vim.o.winborder,
            },
        },
        mappings = {
            n = {
                ["<C-s>"] = { action = "" },
                ["<C-v>"] = { action = "" },
                ["|"] = { action = "select", args = { vsplit = true } },
            },
        },
        ui = {
            indent_guides = true,
        },
    },
}
