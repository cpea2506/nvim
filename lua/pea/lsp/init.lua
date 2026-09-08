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
            ---@cast vim.diagnostic.severity +vim.diagnostic.SeverityName
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

lib.create_autocmds {
    {
        "LspAttach",
        augroup,
        function(args)
            local buf = args.buf
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

            require("pea.lsp.keymaps").set(buf)

            for _, method in pairs(require "pea.lsp.methods") do
                method(client, buf)
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
            local client = assert(vim.lsp.get_client_by_id(data.client_id))

            ---@type lsp.ProgressParams
            local params = data.params
            ---@cast params.value { kind: "begin" | "report" | "end", percentage: integer, message: string, title: string }
            local value = params.value

            local is_done = value.kind == "end"
            local icon = lib.icons.ui.Tick

            if not is_done then
                local spinner = lib.icons.ui.Spinner
                local percentage = value.percentage or 0
                local frame = math.min(math.floor((percentage / 100) * #spinner) + 1, #spinner)

                if spinner[frame] then
                    icon = spinner[frame]
                end
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
