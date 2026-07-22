vim.lsp.codelens = require "pea.lsp.codelens"

vim.diagnostic.config {
    update_in_insert = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = lib.icons.diagnostics.ERROR,
            [vim.diagnostic.severity.WARN] = lib.icons.diagnostics.WARN,
            [vim.diagnostic.severity.HINT] = lib.icons.diagnostics.HINT,
            [vim.diagnostic.severity.INFO] = lib.icons.diagnostics.INFO,
        },
    },
    virtual_lines = {
        current_line = true,
        format = function(diagnostic)
            local severity = vim.diagnostic.severity[diagnostic.severity]

            return lib.icons.diagnostics[severity] .. " " .. diagnostic.message
        end,
    },
    severity_sort = true,
    float = {
        source = "if_many",
        severity_sort = true,
    },
}

local augroup = vim.api.nvim_create_augroup "pea_lsp"
local namespace = vim.api.nvim_create_namespace "pea_lsp"

lib.create_autocmds {
    {
        "LspAttach",
        augroup,
        function(args)
            local buf = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            if not client then
                return
            end

            require("pea.lsp.keymaps").set(buf)

            if client:supports_method("textDocument/inlayHint", buf) then
                vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            end

            if client:supports_method("textDocument/documentColor", buf) then
                vim.lsp.document_color.enable(true, { bufnr = buf, client_id = client.id }, { style = "virtual" })
            end

            if client:supports_method("textDocument/onTypeFormatting", buf) then
                vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
            end

            if client:supports_method("textDocument/codeLens", buf) then
                vim.lsp.codelens.enable(true, { bufnr = buf, client_id = client.id })
            end

            if client:supports_method("textDocument/documentHighlight", buf) then
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
            end

            if client:supports_method("textDocument/codeAction", buf) then
                lib.create_autocmd("CursorHold", augroup, { buf = buf }, function()
                    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1

                    ---@type { [any]: any }
                    local params = vim.lsp.util.make_range_params(0, "utf-8")
                    params.context = {
                        diagnostics = vim.lsp.diagnostic.from(vim.diagnostic.get(buf, { lnum = current_line })),
                    }

                    vim.lsp.buf_request(buf, "textDocument/codeAction", params, function(err, result)
                        if err or not result then
                            return
                        end

                        vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)

                        if not vim.tbl_isempty(result) then
                            vim.api.nvim_buf_set_extmark(buf, namespace, current_line, 0, {
                                sign_text = "💡",
                                priority = 200,
                            })
                        end
                    end)
                end)
            end
        end,
    },
    {
        "LspDetach",
        augroup,
        function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            if not client then
                return
            end

            vim.api.nvim_clear_autocmds {
                group = augroup,
                buf = bufnr,
            }
        end,
    },
    {
        "LspProgress",
        augroup,
        {
            pattern = { "begin", "report", "end" },
        },
        function(args)
            local data = args.data
            local client = vim.lsp.get_client_by_id(data.client_id)

            if not client then
                return
            end

            ---@type lsp.ProgressParams
            local params = data.params
            local value = params.value

            local is_done = value.kind == "end"
            local icon = lib.icons.ui.Tick

            if not is_done then
                local spinner = lib.icons.ui.Spinner
                local percentage = value.percentage or 0
                local frame = math.min(math.floor((percentage / 100) * #spinner) + 1, #spinner)

                icon = spinner[frame]
            end

            vim.api.nvim_echo({ { is_done and "Done" or value.message or "", "Type" } }, true, {
                id = ("%s.%s"):format(client.id, params.token),
                kind = "progress",
                status = is_done and "success" or "running",
                percent = value.percentage,
                title = ("%s [%s] %s"):format(icon, client.name, value.title or ""),
                source = "lsp",
            })
        end,
    },
}
