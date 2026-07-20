return {
    settings = {
        emmylua = {
            format = {
                externalTool = {
                    program = "stylua",
                    args = {
                        "-",
                        "--stdin-filepath",
                        "${file}",
                    },
                },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
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
