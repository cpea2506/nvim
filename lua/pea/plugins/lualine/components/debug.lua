local component = require("lualine.component"):extend()

function component:init(options)
    component.super.init(self, options)

    local icons = require "pea.ui.icons"
    self.icon = icons.ui.Bug

    vim.api.nvim_create_autocmd("User", {
        pattern = "DebugModeChanged",
        group = vim.api.nvim_create_augroup("pea_lualine_debug", {}),
        callback = function(args)
            self.enabled = args.data.enabled
        end,
    })
end

function component:update_status()
    return self.enabled and self.icon or ""
end

return component
