require("config.lazy")

-- basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"

-- Highlight search
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>a', 'ggVG')

--[[
-- pack available from neovim 0.12
vim.pack.add({
  "https://github.com/vague2k/vague.nvim",
})

require("vague").setup({
    -- optional configuration here
})

vim.cmd("colorscheme vague")
]] --


vim.diagnostic.config({
    virtual_text = true,      -- show inline messages
    signs = true,             -- keep the E/W in the gutter
    underline = true,         -- underline the problematic code
    update_in_insert = false, -- don't update while typing
    severity_sort = true,
})

-- Set tab width to 2 for js/ts
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr }

        -- Common keymaps for LSP
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        -- Autoformat files with Alt+Shift+F
        vim.keymap.set("n", "<M-F>", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})
