vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
    once = true,
    callback = function()
        vim.pack.add { "https://github.com/mfussenegger/nvim-lint" }

        local lint = require "lint"
        lint.linters_by_ft = {
            sh = { "shellcheck" },
        }

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
            callback = function()
                lint.try_lint()
            end,
        })
    end,
})
