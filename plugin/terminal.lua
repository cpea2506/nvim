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

    local augroup = vim.api.nvim_create_augroup "pea.plugin.terminal"

    lib.create_autocmds {
        {
            "TermOpen",
            augroup,
            function(args)
                local buf = args.buf

                if opts.input then
                    send(buf, opts.input)
                end

                vim.wo.winfixwidth = true
                vim.wo.winfixheight = true
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

    vim.cmd(cmd)
end

local function get_ai_editor()
    if not vim.env.AI_EDITOR then
        vim.notify("AI_EDITOR environment variable is not set", vim.log.levels.ERROR)
        return
    end

    return vim.env.AI_EDITOR
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
            local command = get_ai_editor()

            if command then
                open(command, { direction = "vertical", size = 80 })
            end
        end,
    },
    {
        "x",
        "<leader>ai",
        function()
            local command = get_ai_editor()

            if command then
                local lines = vim.fn.getregion(vim.fn.getpos ".", vim.fn.getpos "v", {
                    type = vim.api.nvim_get_mode().mode,
                })
                local input = table.concat(lines, "\n")

                open(command, { direction = "vertical", size = 80, input = input })
            end
        end,
    },
    {
        "n",
        "<leader>ac",
        function()
            local command = get_ai_editor()

            if command then
                open(command .. " --continue", { direction = "vertical", size = 80 })
            end
        end,
    },
}
