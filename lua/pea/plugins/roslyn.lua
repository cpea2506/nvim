return {
	"seblj/roslyn.nvim",
	ft = "cs",
	opts = {
		config = {
			settings = {
				["csharp|inlay_hints"] = {
					["csharp_enable_inlay_hints_for_implicit_object_creation"] = true,
					["csharp_enable_inlay_hints_for_implicit_variable_types"] = true,
					["csharp_enable_inlay_hints_for_lambda_parameter_types"] = true,
					["csharp_enable_inlay_hints_for_types"] = true,
					["dotnet_enable_inlay_hints_for_indexer_parameters"] = true,
					["dotnet_enable_inlay_hints_for_literal_parameters"] = true,
					["dotnet_enable_inlay_hints_for_object_creation_parameters"] = true,
					["dotnet_enable_inlay_hints_for_other_parameters"] = true,
					["dotnet_enable_inlay_hints_for_parameters"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent"] = true,
				},
			},
			on_attach = function(client, bufnr)
				-- Make sure this happens once per client, not per buffer
				if not client.is_hacked then
					client.is_hacked = true

					-- Let the runtime know the server can do semanticTokens/full now
					client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
						semanticTokensProvider = {
							full = true,
						},
					})

					-- Monkey patch the request proxy
					local request_inner = client.request
					client.request = function(method, params, handler)
						if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
							return request_inner(method, params, handler)
						end

						local function find_buf_by_uri(search_uri)
							local bufs = vim.api.nvim_list_bufs()
							for _, buf in ipairs(bufs) do
								local name = vim.api.nvim_buf_get_name(buf)
								local uri = "file://" .. name
								if uri == search_uri then
									return buf
								end
							end
						end

						local doc_uri = params.textDocument.uri
						local target_bufnr = find_buf_by_uri(doc_uri)
						local line_count = vim.api.nvim_buf_line_count(target_bufnr or bufnr)
						local last_line =
							vim.api.nvim_buf_get_lines(target_bufnr or bufnr, line_count - 1, line_count, true)[1]

						return request_inner("textDocument/semanticTokens/range", {
							textDocument = params.textDocument,
							range = {
								["start"] = {
									line = 0,
									character = 0,
								},
								["end"] = {
									line = line_count - 1,
									character = string.len(last_line) - 1,
								},
							},
						}, handler)
					end
				end
			end,
		},
		exe = vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
		filewatching = true,
	},
}
