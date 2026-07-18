local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

local function open_term(cmd, opts)
    opts = opts or {}

    if opts.size then
        vim.cmd(("botright %d vsplit | term %s"):format(opts.size, cmd))
    else
        vim.cmd(("tabnew | term %s"):format(cmd))
    end
end

lib.set_keymaps {
    { "t", "<C-\\>", [[<C-\><C-n>]] },
    {
        "n",
        "<leader>gg",
        function()
            open_term "lazygit"
        end,
    },
    {
        "n",
        "<leader>ai",
        function()
            open_term("opencode", { size = 80 })
        end,
    },
    {
        "n",
        "<leader>ac",
        function()
            open_term("opencode --continue", { size = 80 })
        end,
    },
}

lib.create_autocmds {
    {
        "TermOpen",
        augroup,
        function()
            vim.cmd.startinsert()
        end,
    },
    {
        "TermClose",
        augroup,
        function(args)
            local buf = args.buf

            if buf and vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end,
    },
}
