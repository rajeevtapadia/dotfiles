require("config.lazy")

-- basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.o.smartcase = true
vim.opt.signcolumn = "yes"

-- Highlight search
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('i', '<C-H>', '<C-W>', { noremap = true })

--[[
-- pack available from neovim 0.12
vim.pack.add({
  "https://github.com/vague2k/vague.nvim",
})

require("vague").setup({
    -- optional configuration here
})

vim.cmd("colorscheme vague")
]]-- 


vim.diagnostic.config({
    virtual_text = true,   -- show inline messages
    signs = true,          -- keep the E/W in the gutter
    underline = true,      -- underline the problematic code
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
