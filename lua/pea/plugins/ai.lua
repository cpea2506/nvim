return {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
        {
            "<Tab>",
            function()
                if not require("sidekick").nes_jump_or_apply() then
                    return "<Tab>"
                end
            end,
            expr = true,
            desc = "Goto/Apply Next Edit Suggestion",
        },
        {
            "<leader>ai",
            function()
                require("sidekick.cli").toggle { name = "copilot", focus = true }
            end,
            desc = "Sidekick Toggle Copilot CLI",
        },
    },
}
