vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
    once = true,
    callback = function()
        vim.pack.add {
            "https://github.com/lewis6991/gitsigns.nvim",
            "https://github.com/esmuellert/codediff.nvim",
        }

        require("gitsigns").setup {
            attach_to_untracked = true,
            current_line_blame = true,
            current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y> (<author_time:%R>) "
                .. lib.icons.ui.CircleMedium
                .. " <summary>",
        }
    end,
})
