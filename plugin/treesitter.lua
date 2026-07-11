vim.schedule(function()
    vim.schedule(function()
        vim.pack.add {
            "https://github.com/arborist-ts/arborist.nvim",
            "https://github.com/nvim-treesitter/nvim-treesitter-context",
        }

        require("arborist").setup()
        require("treesitter-context").setup {
            mode = "cursor",
            max_lines = 3,
        }

        vim.keymap.set("n", "[c", function()
            require("treesitter-context").go_to_context(vim.v.count1)
        end, { desc = "Go To Context" })
    end)
end)
