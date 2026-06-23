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

local augroup = vim.api.nvim_create_augroup("pea_lsp", {})
local namespace = vim.api.nvim_create_namespace "pea_lsp"

lib.create_autocmds {
    {
        "LspAttach",
        augroup,
        function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            if not client then
                return
            end

            require("pea.lsp.keymaps").set(bufnr)

            if client:supports_method("textDocument/inlayHint", bufnr) then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end

            if client:supports_method("textDocument/documentColor", bufnr) then
                vim.lsp.document_color.enable(true, { bufnr = bufnr, client_id = client.id }, { style = "virtual" })
            end

            if client:supports_method("textDocument/onTypeFormatting", bufnr) then
                vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
            end

            if client:supports_method("textDocument/codeLens", bufnr) then
                vim.lsp.codelens.enable(true, { bufnr = bufnr, client_id = client.id })
            end

            if client:supports_method("textDocument/documentHighlight", bufnr) then
                lib.create_autocmds {
                    {
                        { "CursorHold", "CursorHoldI" },
                        augroup,
                        {
                            buf = bufnr,
                        },
                        vim.lsp.buf.document_highlight,
                    },
                    {
                        "CursorMoved",
                        augroup,
                        {
                            buf = bufnr,
                        },
                        vim.lsp.buf.clear_references,
                    },
                }
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
    {
        "CursorHold",
        augroup,
        function(args)
            local buf = args.buf
            local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1

            ---@type { [any]: any }
            local params = vim.lsp.util.make_range_params(0, "utf-8")
            params.context = {
                diagnostics = vim.lsp.diagnostic.from(vim.diagnostic.get(buf, { lnum = current_line })),
            }

            vim.lsp.buf_request_all(buf, "textDocument/codeAction", params, function(responses)
                vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)

                for _, response in pairs(responses) do
                    if response.result and not vim.tbl_isempty(response.result) then
                        vim.api.nvim_buf_set_extmark(buf, namespace, current_line, 0, {
                            sign_text = "💡",
                            priority = 200,
                        })

                        break
                    end
                end
            end)
        end,
    },
}
