return{
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional:
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        { 'j-hui/fidget.nvim' },
        },
        config = function()
            local lsp = require("lsp-zero")
            local lsp_config = require("lspconfig")
            lsp.preset("recommended")

            lsp.ensure_installed({
                'tsserver',
                'rust_analyzer',
                'lua_ls',
                'htmx-lsp',
            })

            -- Fix Undefined global 'vim'
            lsp.nvim_workspace()


            local cmp = require('cmp')
            local cmp_select = {behavior = cmp.SelectBehavior.Select}
            local cmp_keymaps = lsp.defaults.cmp_mappings({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            })

            cmp_keymaps['<Tab>'] = nil
            cmp_keymaps['<S-Tab>'] = nil

            lsp.setup_nvim_cmp({
                mapping = cmp_keymaps
            })

            lsp.set_preferences({
                suggest_lsp_servers = true,
                sign_icons = {
                    error = 'E',
                    warn = 'W',
                    hint = 'H',
                    info = 'I'
                }
            })
            local onAttach = function(client, bufnr)
                local opts = {buffer = bufnr, remap = false}

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end

            lsp.on_attach(onAttach)
            lsp_config["dartls"].setup({

                on_attach = onAttach,
                settings ={
                    dart = {
                        analysisExcludedFolder = {
                            vim.fn.expand("$Home/AppData/Local/Pub/Cache"),
                            vim.fn.expand("$Home/.pub-cache"),
                            vim.fn.expand("C:/dev/tooling/flutter"),
                        }
                    }

                }

            })
            lsp.setup()
            require("fidget").setup({})
            vim.diagnostic.config({
                virtual_text = true
            })
        end
    }
