return {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
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
    },
}
