vim.schedule(function()
    vim.pack.add { "https://github.com/akinsho/toggleterm.nvim" }

    require("toggleterm").setup {
        open_mapping = "<C-t>",
        direction = "horizontal",
        autochdir = true,
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return 80
            end
        end,
    }

    local function toggle_lazygit()
        local terminal = require("toggleterm.terminal").Terminal

        local lazygit = terminal:new {
            cmd = "lazygit",
            hidden = true,
            direction = "tab",
        }

        lazygit:toggle()
    end

    local function toggle_ai(start_new_session)
        local terminal = require("toggleterm.terminal").Terminal
        local cmd = vim.fn.executable "claude" == 1 and "claude" or "opencode"

        if not start_new_session then
            cmd = cmd .. " --continue"
        end

        local ai = terminal:new {
            cmd = cmd,
            hidden = true,
            direction = "vertical",
        }

        ai:toggle()
    end

    lib.set_keymaps {
        { "t", "<C-\\>", [[<C-\><C-n>]] },
        {
            "n",
            "<leader>gg",
            toggle_lazygit,
        },
        {
            "n",
            "<leader>ai",
            function()
                toggle_ai(true)
            end,
        },
        {
            "n",
            "<leader>ac",
            function()
                toggle_ai(false)
            end,
        },
    }
end)
