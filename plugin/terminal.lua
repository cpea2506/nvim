local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

local function send(buf, text)
    local timer = assert(vim.uv.new_timer())

    timer:start(
        100,
        100,
        vim.schedule_wrap(function()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local non_empty_lines = vim.iter(lines):filter(function(s)
                return s:match "%S" ~= nil
            end)
            local cursor = vim.api.nvim_win_get_cursor(0)

            if non_empty_lines:count() > 5 and cursor[1] > 3 then
                timer:stop()
                timer:close()

                vim.api.nvim_buf_call(buf, function()
                    vim.api.nvim_put(vim.split(text, "\n", { plain = true }), "c", false, true)
                end)
            end
        end)
    )
end

local function open(cmd, opts)
    opts = vim.tbl_deep_extend("force", { direction = "horizontal", size = 15 }, opts or {})

    if opts.direction == "vertical" then
        cmd = ("botright %d vsplit | term %s"):format(opts.size, cmd)
    elseif opts.direction == "horizontal" then
        cmd = ("botright %d split | term %s"):format(opts.size, cmd)
    else
        cmd = ("tabnew | term %s"):format(cmd)
    end

    lib.create_autocmds {
        {
            "TermOpen",
            augroup,
            { once = true },
            function(args)
                if opts.input then
                    send(args.buf, opts.input)
                end

                vim.cmd.startinsert()
            end,
        },
        {
            "TermClose",
            augroup,
            { once = true },
            function(args)
                local buf = args.buf

                if buf and vim.api.nvim_buf_is_valid(buf) then
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
            end,
        },
    }

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
        "x",
        "<leader>ai",
        function()
            local lines = vim.fn.getregion(vim.fn.getpos ".", vim.fn.getpos "v", {
                type = vim.api.nvim_get_mode().mode,
            })
            local input = table.concat(lines, "\n")

            open("opencode", { direction = "vertical", size = 80, input = input })
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
