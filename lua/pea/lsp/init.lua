vim.lsp.codelens = require "pea.lsp.codelens"

vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

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
    underline = true,
    severity_sort = true,
    float = {
        source = true,
        severity_sort = true,
        focusable = true,
        style = "minimal",
        border = "rounded",
    },
}

local augroup = vim.api.nvim_create_augroup("pea_lsp", {})

lib.create_autocmds {
    {
        "LspAttach",
        {
            group = augroup,
            callback = function(args)
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
                    vim.lsp.document_color.enable(true, { client_id = client.id }, { style = "virtual" })
                end

                if client:supports_method("textDocument/onTypeFormatting", bufnr) then
                    vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
                end

                if client:supports_method("textDocument/codeLens", bufnr) then
                    vim.lsp.codelens.enable(true, { client_id = client.id })
                end

                if client:supports_method("textDocument/documentHighlight", bufnr) then
                    local document_highlight_group = vim.api.nvim_create_augroup("pea_lsp_document_highlight", {})

                    lib.create_autocmds {
                        {
                            { "CursorHold", "CursorHoldI" },
                            {
                                group = document_highlight_group,
                                buf = bufnr,
                                callback = vim.lsp.buf.document_highlight,
                            },
                        },
                        {
                            "CursorMoved",
                            {
                                group = document_highlight_group,
                                buf = bufnr,
                                callback = vim.lsp.buf.clear_references,
                            },
                        },
                    }
                end
            end,
        },
    },
    {
        "LspDetach",
        {
            group = augroup,
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                if not client then
                    return
                end

                if client:supports_method("textDocument/documentHighlight", bufnr) then
                    local document_highlight_group =
                        vim.api.nvim_create_augroup("pea_lsp_document_highlight", { clear = false })

                    vim.api.nvim_clear_autocmds {
                        group = document_highlight_group,
                        buf = bufnr,
                    }
                end
            end,
        },
    },
    {
        "LspProgress",
        {
            group = augroup,
            pattern = { "begin", "report", "end" },
            callback = function(args)
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
                    local frame = math.min(math.floor((value.percentage / 100) * #spinner) + 1, #spinner)

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
    },
}
