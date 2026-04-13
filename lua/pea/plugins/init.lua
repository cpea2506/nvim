return {
    {
        "MironPascalCaseFan/debugmaster.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
            "ownself/nvim-dap-unity",
        },
        keys = {
            {
                "<leader>d",
                function()
                    require("debugmaster").mode.toggle()
                end,
                desc = "Toggle Debug Mode",
            },
        },
        config = function()
            local debugmaster = require "debugmaster"

            debugmaster.plugins.cursor_hl.enabled = true
            debugmaster.plugins.ui_auto_toggle.enabled = true
        end,
    },
    {
        "ownself/nvim-dap-unity",
        otps = {
            auto_install_on_start = true,
            add_default_cs_configuration = true,
        },
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local icons = require "pea.ui.icons"

            vim.fn.sign_define("DapBreakpoint", {
                text = icons.ui.Circle,
                texthl = "DapBreakpoint",
                linehl = "Visual",
                numhl = "DapBreakpoint",
            })
            vim.fn.sign_define("DapBreakpointCondition", {
                text = icons.ui.CircleInfo,
                texthl = "DapBreakpoint",
                linehl = "Visual",
                numhl = "DapBreakpoint",
            })
            vim.fn.sign_define("DapBreakpointRejected", {
                text = icons.ui.CircleWarning,
                texthl = "DapBreakpoint",
                linehl = "Visual",
                numhl = "DapBreakpoint",
            })
            vim.fn.sign_define("DapLogPoint", {
                text = icons.ui.CircleInfo,
                texthl = "DapLogPoint",
                linehl = "Visual",
                numhl = "DapLogPoint",
            })
            vim.fn.sign_define("DapStopped", {
                text = icons.ui.CirclePlay,
                texthl = "DapStopped",
                linehl = "Visual",
                numhl = "DapStopped",
            })
        end,
    },
}
