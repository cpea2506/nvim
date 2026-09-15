---@alias lsp.Method fun(client: vim.lsp.Client, buf: integer)

local augroup = vim.api.nvim_create_augroup("pea.lsp", { clear = false })
local namespace = vim.api.nvim_create_namespace "pea.lsp"

---@param what vim.fn.setqflist.what
local function on_list(what)
    if not what.items then
        return
    end

    vim.list.unique(what.items, function(item)
        return (":%s:%d:%s"):format(item.filename, item.lnum, item.text)
    end)

    if #what.items == 1 then
        local item = what.items[1]

        if not item.filename or not item.lnum or not item.col then
            return
        end

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

return {
    ---@type lsp.Method
    definition = function(client, buf)
        if not client:supports_method("textDocument/definition", buf) then
            return
        end

        lib.set_keymap("n", "gd", function()
            vim.lsp.buf.definition { on_list = on_list }
        end, { buf = buf, desc = "Definition" })
    end,
    ---@type lsp.Method
    type_definition = function(client, buf)
        if not client:supports_method("textDocument/typeDefinition", buf) then
            return
        end

        lib.set_keymap("n", "gD", function()
            vim.lsp.buf.type_definition { on_list = on_list }
        end, { buf = buf, desc = "Type Definition" })
    end,
    ---@type lsp.Method
    implementation = function(client, buf)
        if not client:supports_method("textDocument/implementation", buf) then
            return
        end

        lib.set_keymap("n", "gi", function()
            vim.lsp.buf.implementation { on_list = on_list }
        end, { buf = buf, desc = "Implementation" })
    end,
    ---@type lsp.Method
    references = function(client, buf)
        if not client:supports_method("textDocument/references", buf) then
            return
        end

        lib.set_keymap("n", "gr", function()
            vim.lsp.buf.references({ includeDeclaration = false }, { on_list = on_list })
        end, { buf = buf, desc = "References", nowait = true })
    end,
    ---@type lsp.Method
    rename = function(client, buf)
        if not client:supports_method "textDocument/rename" then
            return
        end

        lib.set_keymap("n", "gn", function()
            vim.lsp.buf.rename(nil, { bufnr = buf })
        end, { buf = buf, desc = "Rename" })
    end,
    ---@type lsp.Method
    diagnostic = function(client, buf)
        if not client:supports_method("textDocument/diagnostic", buf) then
            return
        end

        lib.set_keymaps {
            {
                "n",
                "gl",
                function()
                    vim.diagnostic.open_float { bufnr = buf }
                end,
                { buf = buf, desc = "Line Diagnostics" },
            },
            {
                "n",
                "gw",
                function()
                    vim.diagnostic.setqflist {
                        severity = {
                            min = vim.diagnostic.severity.WARN,
                            max = vim.diagnostic.severity.ERROR,
                        },
                    }
                end,
                { buf = buf, desc = "Workspace Diagnostics" },
            },
        }
    end,
    ---@type lsp.Method
    inlay_hint = function(client, buf)
        if not client:supports_method("textDocument/inlayHint", buf) then
            return
        end

        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end,
    ---@type lsp.Method
    document_color = function(client, buf)
        if not client:supports_method("textDocument/documentColor", buf) then
            return
        end

        vim.lsp.document_color.enable(true, { bufnr = buf, client_id = client.id }, { style = "virtual" })
    end,
    ---@type lsp.Method
    on_type_formatting = function(client, buf)
        if not client:supports_method("textDocument/onTypeFormatting", buf) then
            return
        end

        vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
    end,
    ---@type lsp.Method
    codelens = function(client, buf)
        if not client:supports_method("textDocument/codeLens", buf) then
            return
        end

        vim.lsp.codelens.enable(true, { bufnr = buf, client_id = client.id })
    end,
    ---@type lsp.Method
    document_highlight = function(client, buf)
        if not client:supports_method("textDocument/documentHighlight", buf) then
            return
        end

        lib.create_autocmds {
            {
                { "CursorHold", "CursorHoldI" },
                augroup,
                {
                    buf = buf,
                },
                vim.lsp.buf.document_highlight,
            },
            {
                "CursorMoved",
                augroup,
                {
                    buf = buf,
                },
                vim.lsp.buf.clear_references,
            },
        }
    end,
    ---@type lsp.Method
    code_action = function(client, buf)
        if not client:supports_method("textDocument/codeAction", buf) then
            return
        end

        lib.set_keymap({ "n", "v" }, "ga", function()
            vim.lsp.buf.code_action()
        end, { buf = buf, desc = "Code Action" })

        lib.create_autocmd("CursorHold", augroup, { buf = buf }, function()
            local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
            local current_diagnostics = vim.diagnostic.get(buf, { lnum = current_line })
            local params = vim.lsp.util.make_range_params(0, "utf-8") ---@as lsp.CodeActionParams
            params.context = { diagnostics = vim.lsp.diagnostic.from(current_diagnostics) }

            vim.lsp.buf_request(buf, "textDocument/codeAction", params, function(err, result)
                vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)

                if err or not result then
                    return
                end

                if not vim.tbl_isempty(result) then
                    vim.api.nvim_buf_set_extmark(buf, namespace, current_line, 0, {
                        sign_text = "💡",
                        priority = 200,
                    })
                end
            end)
        end)
    end,
}
