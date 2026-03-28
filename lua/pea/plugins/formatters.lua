return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
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
    },
}
