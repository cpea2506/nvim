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

local function toggle_copilot()
    local terminal = require("toggleterm.terminal").Terminal

    local copilot = terminal:new {
        cmd = "copilot --banner",
        hidden = true,
        direction = "vertical",
    }

    copilot:toggle(80)
end

return {
    "akinsho/toggleterm.nvim",
    keys = {
        "<C-t>",
        { "<leader>gg", toggle_lazygit, desc = "Lazygit Toggle" },
        { "<leader>ai", toggle_copilot, desc = "Copilot Toggle" },
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
