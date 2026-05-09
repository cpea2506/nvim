return {
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "default",
            dotnet_compiler_diagnostics_scope = "openFiles",
        },
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
        ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
        },
        ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("InsertCharPre", {
            group = vim.api.nvim_create_augroup("pea_lsp", { clear = true }),
            desc = "Trigger an auto insert on '/'.",
            buf = bufnr,
            callback = function()
                local char = vim.v.char

                if char ~= "/" then
                    return
                end

                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local params = {
                    _vs_textDocument = vim.lsp.util.make_text_document_params(bufnr),
                    _vs_position = { line = row - 1, character = col + 1 },
                    _vs_ch = char,
                }

                vim.schedule(function()
                    client:request("textDocument/_vs_onAutoInsert", params, function(err, result, _)
                        if err or not result then
                            return
                        end

                        local newText = result._vs_textEdit.newText:gsub("\r?\n%s*", "\n")
                        vim.snippet.expand(newText)
                    end, bufnr)
                end)
            end,
        })
    end,
}
