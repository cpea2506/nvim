local M = {}

---@param bufnr integer
function M.set(bufnr)
    ---@param what vim.fn.setqflist.what
    local function on_list(what)
        vim.list.unique(what.items, function(item)
            return (":%s:%d:%d:%d:%d:%s"):format(
                item.filename or "",
                item.lnum or 0,
                item.col or 0,
                item.end_lnum or 0,
                item.end_col or 0,
                item.text or ""
            )
        end)

        if #what.items == 1 then
            local item = what.items[1]
            local item_bufnr = item.bufnr or vim.fn.bufadd(item.filename)

            -- Save position in jumplist.
            vim.cmd.normal { "m'", bang = true }

            local winid = vim.api.nvim_get_current_win()
            local curpos = vim.api.nvim_win_get_cursor(winid)
            curpos[1] = item_bufnr

            vim.fn.settagstack(winid, {
                items = {
                    {
                        bufnr = item_bufnr,
                        from = curpos,
                        tagname = vim.fn.expand "<cword>",
                    },
                },
            }, "t")

            vim.bo[item_bufnr].buflisted = true
            vim.api.nvim_win_set_buf(winid, item_bufnr)
            vim.api.nvim_win_set_cursor(winid, { item.lnum, item.col - 1 })
        else
            vim.fn.setqflist({}, " ", what)
            vim.cmd "bo cope"
        end
    end

    local keymaps = {
        {
            "n",
            "gd",
            function()
                vim.lsp.buf.definition { on_list = on_list }
            end,
            { desc = "Definition" },
        },
        {
            "n",
            "gD",
            function()
                vim.lsp.buf.type_definition { on_list = on_list }
            end,
            { desc = "Type Definition" },
        },
        {
            "n",
            "gr",
            function()
                vim.lsp.buf.references(nil, { on_list = on_list })
            end,
            { desc = "References", nowait = true },
        },
        {
            "n",
            "gi",
            function()
                vim.lsp.buf.implementation { on_list = on_list }
            end,
            { desc = "Implementation" },
        },
        { "n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" } },
        {
            "n",
            "gw",
            function()
                vim.diagnostic.setqflist()
            end,
            { desc = "Workspace Diagnostics" },
        },
        { "n", "gn", vim.lsp.buf.rename, { desc = "Rename" } },
        { { "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code Action" } },
        {
            { "n" },
            "gx",
            function()
                vim.lsp.codelens.run()
            end,
            { desc = "Code Action" },
        },
    }

    for _, key in pairs(keymaps) do
        local opts = key[4] or {}
        opts.silent = true
        opts.buf = bufnr

        vim.keymap.set(key[1], key[2], key[3], opts)
    end
end

return M
