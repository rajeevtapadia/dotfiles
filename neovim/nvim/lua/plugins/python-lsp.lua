vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    settings = {
        pylsp = {
            plugins = {
                --             pycodestyle = {
                --                 ignore = { 'E302', 'E305' }, -- E305 is for lines after classes/funcs
                --             },
                --             autopep8 = { enabled = true },
                --         }
                --
                jedi = {
                    environment = vim.fn.getcwd() .. "/.venv",
                },
            },
        }
    }
})

vim.lsp.enable({ "pylsp" })

return {}
