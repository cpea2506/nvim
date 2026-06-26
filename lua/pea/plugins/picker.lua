return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<leader>sg", "<cmd>FzfLua global<cr>", desc = "FzfLua Global" },
        { "<leader>sf", "<cmd>FzfLua files<cr>", desc = "FzfLua Files" },
        { "<leader>st", "<cmd>FzfLua live_grep<cr>", desc = "FzfLua Grep" },
        { "<leader>sb", "<cmd>FzfLua buffers<cr>", desc = "FzfLua Buffers" },
    },
    opts = {
        winopts = {
            height = 0.85,
            width = 0.5,
            row = 0.5,
            col = 0.5,
            title_flags = false,
            preview = {
                layout = "vertical",
                vertical = "up:50%",
                scrollbar = false,
            },
        },
        file_ignore_patterns = { "%.meta$", "%.fbx$", "%.png$", "%.jpg$" },
        fzf_opts = {
            ["--cycle"] = true,
            ["--gutter"] = " ",
            ["--no-scrollbar"] = true,
            ["--pointer"] = lib.icons.ui.ChevronRight,
            ["--prompt"] = " " .. lib.icons.ui.Telescope .. " ",
        },
        fzf_colors = true,
        files = {
            previewer = lib.is_windows and "bat" or "builtin",
            cwd_prompt = false,
            formatter = "path.filename_first",
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
    },
}
