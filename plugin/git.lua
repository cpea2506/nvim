vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
    once = true,
    callback = function()
        vim.pack.add { "https://github.com/lewis6991/gitsigns.nvim" }

        require("gitsigns").setup {
            signs = {
                add = {
                    text = lib.icons.ui.BoldLine,
                },
                change = {
                    text = lib.icons.ui.BoldLine,
                },
                delete = {
                    text = lib.icons.ui.Triangle,
                },
                topdelete = {
                    text = lib.icons.ui.Triangle,
                },
                changedelete = {
                    text = lib.icons.ui.BoldLine,
                },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            auto_attach = true,
            attach_to_untracked = true,
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 500,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y> (<author_time:%R>) "
                .. lib.icons.ui.CircleMedium
                .. " <summary>",
            sign_priority = 6,
            status_formatter = nil,
            update_debounce = 100,
            max_file_length = 40000,
            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
        }
    end,
})
