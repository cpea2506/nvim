vim.pack.add {
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/FylerOrg/fyler.nvim",
}

require("fyler").setup {
    auto_confirm_simple_mutation = true,
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
        hidden_items = {
            switches = {},
        },
        indent_guides = true,
    },
}

lib.set_keymap("n", "<leader>e", "<cmd>Fyler<cr>", { desc = "Open Explorer" })
