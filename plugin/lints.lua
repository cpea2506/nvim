vim.schedule(function()
    vim.pack.add { "https://github.com/mfussenegger/nvim-lint" }

    local lint = require "lint"
    lint.linters_by_ft = {
        lua = { "selene" },
        sh = { "shellcheck" },
    }

    local function debounce(ms, fn)
        return function()
            local timer = vim.uv.new_timer()

            if timer then
                timer:start(ms, 0, function()
                    timer:stop()
                    vim.schedule_wrap(fn)()
                end)
            end
        end
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
        callback = debounce(100, lint.try_lint),
    })
end)
