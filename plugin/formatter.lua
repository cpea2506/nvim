local augroup = vim.api.nvim_create_augroup "pea.plugin.formatter"

vim.pack.add({
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/stevearc/conform.nvim",
}, { load = function() end })

lib.create_autocmds {
    {
        { "BufReadPost", "BufNewFile" },
        augroup,
        { once = true },
        function()
            vim.cmd.packadd "conform.nvim"

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
                default_format_opts = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
            }
        end,
    },
    {
        "BufWritePre",
        augroup,
        function(args)
            vim.cmd.packadd "gitsigns.nvim"

            local buf = args.buf
            local hunks = require("gitsigns").get_hunks(buf)

            if not hunks then
                return
            end

            for _, hunk in ipairs(hunks) do
                local start = hunk.added.start
                local count = hunk.added.count

                require("conform").format {
                    bufnr = buf,
                    range = {
                        start = { start, 0 },
                        ["end"] = { start + count, 0 },
                    },
                }
            end
        end,
    },
}
