local augroup = vim.api.nvim_create_augroup "pea.global"

lib.create_autocmds {
    {
        { "TextYankPost", "TextPutPost" },
        augroup,
        function()
            vim.hl.hl_op()
        end,
    },
    {
        "FileType",
        augroup,
        {
            pattern = { "help", "man", "qf", "nvim-pack" },
        },
        function(args)
            lib.set_keymap("n", "q", "<cmd>close<cr>", { buf = args.buf, silent = true })
            vim.bo[args.buf].buflisted = false
        end,
    },
    {
        "BufReadPost",
        augroup,
        function(args)
            local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
            local line_count = vim.api.nvim_buf_line_count(args.buf)

            if mark[1] > 0 and mark[1] <= line_count then
                vim.cmd.normal { [[g'"zz]], bang = true }
            end
        end,
    },
    {
        "CmdAtom",
        augroup,
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
