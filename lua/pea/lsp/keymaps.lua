local M = {}

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

---@param bufnr integer
function M.set(bufnr)
    lib.set_keymaps {
        {
            "n",
            "gd",
            function()
                vim.lsp.buf.definition { on_list = on_list }
            end,
            { buf = bufnr, desc = "Definition" },
        },
        {
            "n",
            "gD",
            function()
                vim.lsp.buf.type_definition { on_list = on_list }
            end,
            { buf = bufnr, desc = "Type Definition" },
        },
        {
            "n",
            "gr",
            function()
                vim.lsp.buf.references(nil, { on_list = on_list })
            end,
            { buf = bufnr, desc = "References", nowait = true },
        },
        {
            "n",
            "gi",
            function()
                vim.lsp.buf.implementation { on_list = on_list }
            end,
            { buf = bufnr, desc = "Implementation" },
        },
        { "n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" } },
        {
            "n",
            "gw",
            function()
                vim.diagnostic.setqflist()
            end,
            { buf = bufnr, desc = "Workspace Diagnostics" },
        },
        { "n", "gn", vim.lsp.buf.rename, { desc = "Rename" } },
        { { "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code Action" } },
        {
            { "n" },
            "gk",
            function()
                vim.lsp.codelens.run()
            end,
            { buf = bufnr, desc = "Code Action" },
        },
    }
end

return M
