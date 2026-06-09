return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            workspace = {
                checkThirdParty = "ApplyInMemory",
                library = {
                    vim.env.VIMRUNTIME
                },
            },
            codeLens = {
                enable = true,
            },
            completion = {
                callSnippet = "Replace",
            },
            hint = {
                enable = true,
                setType = true,
                arrayIndex = "Disable",
            },
        },
    },
}
