vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", ".git" },

    settings = {
        typescript = {
            suggest = {
                autoImports = true,
            },
        },
        javascript = {
            suggest = {
                autoImports = true,
            },
        },
    },
})

-- Enable TypeScript server
vim.lsp.enable({ "ts_ls" })

return {}
