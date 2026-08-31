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
