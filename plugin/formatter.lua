local augroup = vim.api.nvim_create_augroup "pea.plugin.formatter"

vim.pack.add({
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/stevearc/conform.nvim",
}, { load = function() end })

lib.create_autocmd({ "BufReadPost", "BufNewFile" }, augroup, { once = true }, function()
    vim.cmd.packadd "gitsigns.nvim"
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
            sh = { "shfmt" }
        },
        default_format_opts = {
            timeout_ms = 500,
            lsp_format = "fallback"
        },
        format_on_save = function(buf)
            local hunks = require("gitsigns").get_hunks(buf)

            if not hunks then
                return
            end

            for _, hunk in ipairs(hunks) do
                if not hunk or hunk.type == "delete" then
                    return
                end

                ---@type integer
                local start = hunk.added.start
                local last = start + hunk.added.count 
                local last_hunk_line = vim.api.nvim_buf_get_lines(buf, last - 2, last - 1, true)[1]

                if not last_hunk_line then
                    return
                end

                require("conform").format {
                    bufnr = buf,
                    range = {
                        start = { start, 0 },
                        ["end"] = { last - 1, last_hunk_line:len() },
                    }
                }
            end
        end,
    }
end)
