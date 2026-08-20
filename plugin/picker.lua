vim.schedule(function()
    vim.pack.add { "https://github.com/ibhagwan/fzf-lua" }

    require("fzf-lua").setup {
        winopts = {
            height = 0.85,
            width = 0.5,
            row = 0.5,
            col = 0.5,
            title_flags = false,
            preview = {
                layout = "vertical",
                vertical = "up:50%",
            },
        },
        file_ignore_patterns = { "%.meta$", "%.fbx$", "%.png$", "%.jpg$" },
        fzf_opts = {
            ["--cycle"] = true,
            ["--gutter"] = " ",
            ["--pointer"] = lib.icons.ui.ChevronRight,
            ["--prompt"] = " " .. lib.icons.ui.Telescope .. " ",
            ["--highlight-line"] = true,
        },
        fzf_colors = true,
        files = {
            previewer = false,
            cwd_prompt = false,
            formatter = "path.filename_first",
            winopts = {
                height = 0.35,
                width = 0.4,
            },
        },
        grep = {
            hidden = true,
        },
        keymap = {
            builtin = {
                true,
                ["<C-d>"] = "preview-page-down",
                ["<C-u>"] = "preview-page-up",
            },
            fzf = {
                true,
                ["ctrl-d"] = "preview-page-down",
                ["ctrl-u"] = "preview-page-up",
            },
        },
    }

    lib.set_keymaps {
        { "n", "<leader>sf", "<cmd>FzfLua files<cr>", { desc = "FzfLua Files" } },
        { "n", "<leader>st", "<cmd>FzfLua live_grep<cr>", { desc = "FzfLua Grep" } },
        { "n", "<leader>sb", "<cmd>FzfLua buffers<cr>", { desc = "FzfLua Buffers" } },
    }
end)
