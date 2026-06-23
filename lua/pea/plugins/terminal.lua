local function toggle_lazygit()
    local terminal = require("toggleterm.terminal").Terminal
    local size = 99999

    local lazygit = terminal:new {
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
            border = "none",
            width = size,
            height = size,
        },
    }

    lazygit:toggle()
end

local function toggle_ai(start_new_session)
    local terminal = require("toggleterm.terminal").Terminal
    local cmd = "opencode"

    if not start_new_session then
        cmd = cmd .. " --continue"
    end

    local ai = terminal:new {
        cmd = cmd,
        hidden = true,
        direction = "vertical",
    }

    ai:toggle(80)
end

return {
    "akinsho/toggleterm.nvim",
    keys = {
        "<C-t>",
        { "<leader>gg", toggle_lazygit, desc = "Toggle Lazygit" },
        {
            "<leader>ai",
            function()
                toggle_ai(true)
            end,
            desc = "Toggle New AI Session",
        },
        {
            "<leader>ac",
            function()
                toggle_ai(false)
            end,
            desc = "Toggle Last AI Session",
        },
    },
    opts = {
        open_mapping = "<C-t>",
        direction = "horizontal",
        close_on_exit = true,
        shade_terminals = false,
        autochdir = true,
        size = 15,
    },
}
