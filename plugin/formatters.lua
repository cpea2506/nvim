lib.create_autocmd(
    { "BufReadPost", "BufNewFile" },
    vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
    { once = true },
    function()
        vim.pack.add { "https://github.com/stevearc/conform.nvim" }

        require("conform").setup {
            formatters_by_ft = {
                json = { "prettier" },
                jsonc = { "prettier" },
                markdown = { "prettier" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                cpp = { "clang-format" },
                toml = { "taplo" },
                sh = { "shfmt" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        }
    end
)
