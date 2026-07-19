return {
    settings = {
        emmylua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            runtime = {
                requirePattern = {
                    "?.lua",
                    "?/init.lua",
                },
            },
            completion = {
                callSnippet = true,
            },
            hint = {
                indexHint = false,
            },
        },
    },
}
