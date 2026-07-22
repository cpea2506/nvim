lib.create_autocmd(
    { "BufReadPost", "BufNewFile" },
    vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
    { once = true },
    function()
        vim.pack.add { "https://github.com/mfussenegger/nvim-lint" }

        local lint = require "lint"
        lint.linters_by_ft = {
            sh = { "shellcheck" },
        }

        lib.create_autocmd(
            { "BufReadPost", "BufWritePost", "InsertLeave" },
            vim.api.nvim_create_augroup "pea_plugin",
            function()
                lint.try_lint()
            end
        )
    end
)
