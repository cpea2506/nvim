return {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
        {
            "<leader>ai",
            function()
                require("sidekick.cli").toggle { name = "copilot", focus = true }
            end,
            desc = "Sidekick Toggle Copilot CLI",
        },
    },
}
