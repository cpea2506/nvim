return {
    "FylerOrg/fyler.nvim",
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    opts = {
        integrations = {
            icon = "nvim_web_devicons",
        },
        extensions = {
            trash = {
                enabled = true,
            },
        },
        kind = "floating",
        kind_presets = {
            floating = {
                border = vim.o.winborder,
            },
        },
        mappings = {
            n = {
                ["<C-s>"] = { disabled = true },
                ["<C-v>"] = { disabled = true },
                ["|"] = { action = "select", args = { vsplit = true } },
            },
        },
        ui = {
            indent_guides = true,
        },
    },
}
