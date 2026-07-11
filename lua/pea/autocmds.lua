local augroup = vim.api.nvim_create_augroup

lib.create_autocmds {
    {
        { "TextYankPost", "TextPutPost" },
        augroup("pea_highlight_op", {}),
        function()
            vim.hl.hl_op()
        end,
    },
    {
        "FileType",
        augroup("pea_q_close", {}),
        {
            pattern = { "help", "man", "qf", "checkhealth", "nvim-pack" },
        },
        function(args)
            local buf = args.buf

            vim.keymap.set("n", "q", function()
                vim.api.nvim_buf_delete(buf, { force = true })
            end, { buf = buf, silent = true })
        end,
    },
    {
        "VimResized",
        augroup("pea_resize_splits", {}),
        function()
            vim.cmd.tabdo "wincmd ="
            vim.cmd.tabnext(vim.api.nvim_get_current_tabpage())
        end,
    },
    {
        "TermClose",
        augroup("pea_term_close", {}),
        function(args)
            local buf = args.buf

            vim.api.nvim_buf_delete(buf, { force = true })
        end,
    },
}
