local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

local function open(cmd, opts)
    opts = vim.tbl_deep_extend("force", { direction = "horizontal", size = 15 }, opts or {})

    if opts.direction == "vertical" then
        cmd = ("botright %d vsplit | term %s"):format(opts.size, cmd)
    elseif opts.direction == "horizontal" then
        cmd = ("botright %d split | term %s"):format(opts.size, cmd)
    else
        cmd = ("tabnew | term %s"):format(cmd)
    end

    vim.cmd(cmd)
end

lib.set_keymaps {
    { "t", "<C-\\>", [[<C-\><C-n>]] },
    {
        "n",
        "<leader>gg",
        function()
            open("lazygit", { direction = "tab" })
        end,
    },
    {
        "n",
        "<leader>ai",
        function()
            open("opencode", { direction = "vertical", size = 80 })
        end,
    },
    {
        "n",
        "<leader>ac",
        function()
            open("opencode --continue", { direction = "vertical", size = 80 })
        end,
    },
}

lib.create_autocmds {
    {
        "TermOpen",
        augroup,
        { pattern = "term://*" },
        function()
            vim.cmd.startinsert()
        end,
    },
    {
        "TermClose",
        augroup,
        { pattern = "term://*" },
        function(args)
            local buf = args.buf

            if buf and vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end,
    },
}
