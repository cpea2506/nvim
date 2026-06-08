local augroup = vim.api.nvim_create_augroup

lib.create_autocmds {
    {
        "TextYankPost",
        {
            group = augroup("pea_highlight_yank", {}),
            callback = function()
                vim.hl.hl_op()
            end,
        },
    },
    {
        "TextPutPost",
        {
            group = augroup("pea_highlight_put", {}),
            callback = function()
                vim.hl.hl_op()
            end,
        },
    },
    {
        "FileType",
        {
            group = augroup("pea_q_close", {}),
            pattern = { "help", "man", "qf", "checkhealth" },
            callback = function(args)
                local bufnr = args.buf

                vim.keymap.set("n", "q", function()
                    vim.cmd.bd(bufnr)
                end, { buf = bufnr, silent = true })
            end,
        },
    },
    {
        { "FocusGained", "TermClose", "TermLeave" },
        {
            group = augroup("pea_checktime", {}),
            callback = function()
                if vim.o.buftype ~= "nofile" then
                    vim.cmd.checktime()
                end
            end,
        },
    },
    {
        "VimResized",
        {
            group = augroup("pea_resize_splits", {}),
            callback = function()
                local current_tab = vim.api.nvim_get_current_tabpage()

                vim.cmd.tabdo "wincmd ="
                vim.cmd.tabnext(current_tab)
            end,
        },
    },
}
