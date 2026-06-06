local lib = require "pea.lib"

local function augroup(name)
    return vim.api.nvim_create_augroup("pea_" .. name, { clear = true })
end

lib.create_autocmds {
    {
        "TextYankPost",
        {
            group = augroup "highlight_yank",
            callback = function()
                vim.hl.hl_op()
            end,
        },
    },
    {
        "TextPutPost",
        {
            group = augroup "highlight_put",
            callback = function()
                vim.hl.hl_op()
            end,
        },
    },
    {
        "FileType",
        {
            group = augroup "q_close",
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
            group = augroup "checktime",
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
            group = augroup "resize_splits",
            callback = function()
                local current_tab = vim.api.nvim_get_current_tabpage()

                vim.cmd.tabdo "wincmd ="
                vim.cmd.tabnext(current_tab)
            end,
        },
    },
}
