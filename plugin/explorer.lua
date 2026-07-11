vim.schedule(function()
    vim.pack.add {
        "https://github.com/nvim-tree/nvim-web-devicons",
        "https://github.com/FylerOrg/fyler.nvim",
    }

    require("fyler").setup {
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
    }

    vim.keymap.set("n", "<leader>e", "<cmd>Fyler<cr>", { desc = "Open Explorer" })
end)
