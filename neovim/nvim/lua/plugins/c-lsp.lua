vim.lsp.config("clangd", {
    cmd = { "clangd", "--enable-config", "--background-index", "--suggest-missing-includes" },
    settings = {
        clangd = {
            diagnostics = {
                enable = true,
                showUnused = true,
                enableExperimental = true,
            },
        },
    },
})

-- Enable clangd
vim.lsp.enable({ "clangd" })

return {}
