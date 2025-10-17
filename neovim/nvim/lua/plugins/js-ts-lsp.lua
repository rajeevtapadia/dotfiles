vim.lsp.config("tsserver", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    settings = {
        tsserver = {
            disableAutomaticTypeAcquisition = false,
            diagnostics = { enable = true },
            suggest = { autoImports = true },
        },
    },
})

-- Enable TypeScript server
vim.lsp.enable({ "tsserver" })

return {}
