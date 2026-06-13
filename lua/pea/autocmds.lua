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
            pattern = { "help", "man", "qf", "checkhealth" },
        },
        function(args)
            local bufnr = args.buf

            vim.keymap.set("n", "q", function()
                vim.cmd.bd(bufnr)
            end, { buf = bufnr, silent = true })
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
}
