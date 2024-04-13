local icons = require("pea.icons").diagnostics

return {
	{
		"neovim/nvim-lspconfig",
		event = "BufRead",
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			diagnostics = {
				update_in_insert = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.ERROR,
						[vim.diagnostic.severity.WARN] = icons.WARN,
						[vim.diagnostic.severity.HINT] = icons.HINT,
						[vim.diagnostic.severity.INFO] = icons.INFO,
					},
				},
				virtual_text = {
					prefix = function(diagnostic)
						local severity = vim.diagnostic.severity[diagnostic.severity]

						return icons[severity]
					end,
				},
				underline = true,
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
				},
			},
		},
		config = function(_, opts)
			local register_capability = vim.lsp.handlers["client/registerCapability"]

			vim.diagnostic.config(opts.diagnostics)

			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				local ret = register_capability(err, res, ctx)

				-- local client = vim.lsp.get_client_by_id(ctx.client_id)
				-- local buffer = vim.api.nvim_get_current_buf()
				-- require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
				return ret
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					if client then
						if client.supports_method("textDocument/inlayHint") then
							vim.lsp.inlay_hint.enable(bufnr, true)
						end

						if client.supports_method("textDocument/codeLens") then
							vim.lsp.codelens.refresh()
							vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
								buffer = bufnr,
								callback = vim.lsp.codelens.refresh,
							})
						end
					end
				end,
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							hint = {
								enable = true,
								setType = true,
								arrayIndex = "Disable",
							},
							semantic = {
								keyword = true,
							},
							diagnostics = {
								disable = {
									"missing-parameter",
									"param-type-mismatch",
									"undefined-global",
								},
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				nvim_lsp.default_capabilities() or {}
			)

			local function setup(server)
				local server_opts = opts.servers[server]

				if type(server_opts) == "function" then
					server_opts()

					return
				end

				server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, server_opts or {})

				lspconfig[server].setup(server_opts)
			end

			require("mason-lspconfig").setup({
				ensure_installed = opts.ensure_installed,
				handlers = { setup },
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = {
			{ "<leader>lI", "<cmd>Mason<cr>", desc = "Mason" },
		},
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
			},
			ui = {
				border = "rounded",
				keymaps = {
					toggle_package_expand = "o",
					uninstall_package = "d",
				},
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			local registry = require("mason-registry")

			registry:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = registry.get_package(tool)

					if not p:is_installed() then
						p:install()
					end
				end
			end

			if registry.refresh then
				registry.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}