vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})

-- Enable clangd
vim.lsp.enable({ "lua_ls" })

return {}
