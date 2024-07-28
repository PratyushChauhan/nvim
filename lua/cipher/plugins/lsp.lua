return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        {
            "L3MON4D3/LuaSnip",
            dependencies = { "rafamadriz/friendly-snippets" },
        },
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                --[[
                ["dartls"] = function()
                    local lspconfig = require("lspconfig")
                    require 'lspconfig'.dartls.setup {
                        root_dir = lspconfig.util.root_pattern("pubspec.yaml"),
                        cmd = { "dart", "language-server", "--protocol=lsp" },
                        capabilities = capabilities,
                        init_options = {
                            closingLabels = true,
                            flutterOutline = true,
                            onlyAnalyzeProjectsWithOpenFiles = true,
                            outline = true,
                            suggestFromUnimportedLibraries = true
                        },
                        filetypes = { "dart" },
                        settings = {
                            dart = {
                                completeFunctionCalls = true,
                                showTodos = true
                            }
                        }
                    }
                end,
                --]]

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local lspconfig = require("lspconfig")
        require 'lspconfig'.dartls.setup {
            root_dir = lspconfig.util.root_pattern("pubspec.yaml"),
            cmd = { "dart", "language-server", "--protocol=lsp" },
            capabilities = capabilities,
            init_options = {
                closingLabels = true,
                flutterOutline = true,
                onlyAnalyzeProjectsWithOpenFiles = true,
                outline = true,
                suggestFromUnimportedLibraries = true
            },
            filetypes = { "dart" },
            settings = {
                dart = {
                    completeFunctionCalls = true,
                    showTodos = true,
                    analysisExcludedFolders = { '$Home/AppData/Local/Pub/Cache', "$Home/.pub-cache", "C:/dev/tooling/flutter", }
                }
            }
        }
        lspconfig.htmx.setup {
            cmd = { "htmx-lsp" },
            filetypes = { "html", "templ" },
            single_file_support = true,
        }
        --Enable (broadcasting) snippet capability for completion
        local capabilitiesHtml = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        require 'lspconfig'.html.setup {
            capabilities = capabilitiesHtml,
            cmd = { "vscode-html-language-server", "--stdio" },
            filetypes = { "html", "templ" },
            init_options = {
                configurationSection = { "html", "css", "javascript" },
                embeddedLanguages = {
                    css = true,
                    javascript = true
                },
                provideFormatter = true
            },
            settings = {
            },
            single_file_support = true,
        }


        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<Tab>'] = nil,
                ['<S-Tab>'] = nil,
            }),
            sources = cmp.config.sources({
                    -- Copilot Source
                    { name = "copilot",  group_index = 3, max_item_count = 1 },
                    -- Other Sources
                    { name = 'nvim_lsp', group_index = 1, },
                    { name = 'luasnip',  group_index = 2, }, -- For luasnip users.
                },
                {
                    { name = 'buffer', group_index = 2, },
                })
        })
        require("luasnip.loaders.from_vscode").lazy_load({
            exclude = {}, -- List of language servers to exclude
        })


        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
