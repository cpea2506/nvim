local component = require("lualine.component"):extend()

function component:init(options)
    component.super.init(self, options)

    lib.create_autocmd(
        "User",
        vim.api.nvim_create_augroup "pea_lualine_debug",
        { pattern = "DebugModeChanged" },
        function(args)
            self.enabled = args.data.enabled
        end
    )
end

function component:update_status()
    return self.enabled and lib.icons.ui.Bug or ""
end

return component
