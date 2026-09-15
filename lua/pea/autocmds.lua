local augroup = vim.api.nvim_create_augroup

lib.create_autocmds {
    {
        { "TextYankPost", "TextPutPost" },
        augroup "pea_highlight_op",
        function()
            vim.hl.hl_op()
        end,
    },
    {
        "FileType",
        augroup "pea_q_close",
        {
            pattern = { "help", "man", "qf", "nvim-pack" },
        },
        function(args)
            local buf = args.buf

            lib.set_keymap("n", "q", function()
                vim.api.nvim_buf_delete(buf, { force = true })
            end, { buf = buf, silent = true })
        end,
    },
    {
        "BufReadPost",
        augroup "pea_restore_cursor",
        function(args)
            local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
            local line_count = vim.api.nvim_buf_line_count(args.buf)

            if mark[1] > 0 and mark[1] <= line_count then
                vim.cmd 'normal! g`"zz'
            end
        end,
    },
    {
        "VimResized",
        augroup "pea_resize_splits",
        function()
            vim.cmd.tabdo "wincmd ="
            vim.cmd.tabnext(vim.api.nvim_get_current_tabpage())
        end,
    },
    {
        "CmdAtom",
        augroup "pea_auto_hlsearch",
        function(args)
            local enable = vim.iter({ "/", "?", "*", "#", "n", "N" }):any(function(cmd)
                return args.data.cmd == cmd
            end)

            if vim.o.hlsearch ~= enable then
                vim.o.hlsearch = enable
            end
        end,
    },
}
