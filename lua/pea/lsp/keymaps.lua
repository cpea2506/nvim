local M = {}

---@param what vim.fn.setqflist.what
local function on_list(what)
    vim.list.unique(what.items, function(item)
        return (":%s:%d:%s"):format(item.filename, item.lnum, item.text)
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
        {
            "n",
            "gl",
            function()
                vim.diagnostic.open_float { bufnr = bufnr }
            end,
            { buf = bufnr, desc = "Line Diagnostics" },
        },
        {
            "n",
            "gw",
            function()
                vim.diagnostic.setqflist {
                    severity = {
                        min = vim.diagnostic.severity.WARN,
                    },
                }
            end,
            { buf = bufnr, desc = "Workspace Diagnostics" },
        },
        {
            "n",
            "gn",
            function()
                vim.lsp.buf.rename(nil, { bufnr = bufnr })
            end,
            { buf = bufnr, desc = "Rename" },
        },
        {
            { "n", "v" },
            "ga",
            function()
                vim.lsp.buf.code_action()
            end,
            { buf = bufnr, desc = "Code Action" },
        },
    }
end

return M
