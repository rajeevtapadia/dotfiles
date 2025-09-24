return {
    -- LSP for C/C++
      
      {
        "neovim/nvim-lspconfig",
        config = function()
          -- 1. Define config for clangd
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

          -- 2. Enable clangd
          vim.lsp.enable({ "clangd" })

          -- 3. Use LspAttach autocmd for keymaps
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local bufnr = args.buf
              local opts = { buffer = bufnr }

              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
              vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
              vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

              -- Autoformat C/C++ files with Alt+Shift+F
              vim.keymap.set("n", "<M-F>", function()
                vim.lsp.buf.format({ async = true })
              end, opts)
            end,
          })
        end,
      },

    -- Autocompletion engine
    {
      "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "windwp/nvim-autopairs", -- autopairs integration
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            -- Connect autopairs with cmp
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
}
