local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

vim.fn.sign_define("DapBreakpoint", {
    text = lib.icons.ui.Circle,
    texthl = "DapBreakpoint",
    linehl = "Visual",
    numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointCondition", {
    text = lib.icons.ui.CircleInfo,
    texthl = "DapBreakpoint",
    linehl = "Visual",
    numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointRejected", {
    text = lib.icons.ui.CircleWarning,
    texthl = "DapBreakpoint",
    linehl = "Visual",
    numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapLogPoint", {
    text = lib.icons.ui.CircleInfo,
    texthl = "DapLogPoint",
    linehl = "Visual",
    numhl = "DapLogPoint",
})
vim.fn.sign_define("DapStopped", {
    text = lib.icons.ui.CirclePlay,
    texthl = "DapStopped",
    linehl = "Visual",
    numhl = "DapStopped",
})

vim.keymap.set("n", "<leader>d", function()
    vim.pack.add {
        "https://github.com/mfussenegger/nvim-dap",
        "https://github.com/MironPascalCaseFan/debugmaster.nvim",
    }

    require("debugmaster").mode.toggle()
end, { desc = "Toggle Debug Mode" })

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "cs",
    once = true,
    callback = function()
        vim.api.nvim_create_autocmd("User", {
            group = augroup,
            pattern = "DebugModeChanged",
            once = true,
            callback = function(args)
                if args.data.enabled then
                    vim.pack.add { "https://github.com/ownself/nvim-dap-unity" }

                    require("nvim-dap-unity").setup {
                        auto_install_on_start = true,
                        add_default_cs_configuration = true,
                    }
                end
            end,
        })
    end,
})
