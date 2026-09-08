local augroup = vim.api.nvim_create_augroup("pea_lsp", { clear = false })
local namespace = vim.api.nvim_create_namespace "pea_lsp"

return {
    completion = function(client, buf)
        if not client:supports_method("textDocument/completion", buf) then
            return
        end

        local capabilities = assert(client.server_capabilities)
        local completionProvider = assert(capabilities.completionProvider)
        local chars = {}

        for i = 32, 126 do
            table.insert(chars, string.char(i))
        end

        completionProvider.triggerCharacters = chars

        vim.lsp.completion.enable(true, client.id, buf, {
            autotrigger = true,
            convert = function(item)
                local kind = vim.lsp.protocol.CompletionItemKind[item.kind]
                local abbr = table.concat {
                    ("%s  %s"):format(lib.icons.kind[kind], item.label),
                    item.labelDetails and item.labelDetails.detail,
                }

                return {
                    abbr = abbr,
                    abbr_hlgroup = "CmpItemKind" .. kind,
                    kind = "",
                }
            end,
        })
    end,
    inlay_hint = function(client, buf)
        if not client:supports_method("textDocument/inlayHint", buf) then
            return
        end

        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end,
    document_color = function(client, buf)
        if not client:supports_method("textDocument/documentColor", buf) then
            return
        end

        vim.lsp.document_color.enable(true, { bufnr = buf, client_id = client.id }, { style = "virtual" })
    end,
    on_type_formatting = function(client, buf)
        if not client:supports_method("textDocument/onTypeFormatting", buf) then
            return
        end

        vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
    end,
    codelens = function(client, buf)
        if not client:supports_method("textDocument/codeLens", buf) then
            return
        end

        vim.lsp.codelens.enable(true, { bufnr = buf, client_id = client.id })
    end,
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
    code_action = function(client, buf)
        if not client:supports_method("textDocument/codeAction", buf) then
            return
        end

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
