return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', tag = 'v1.4.5', opts = {} },
        -- Allows extra capabilities provided by blink.cmp
        {
            'saghen/blink.cmp',
            version = '1.*',
        },
        {
            -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            'folke/lazydev.nvim',
            ft = 'lua',
            ---@module "lazydev"
            ---@type lazydev.Config
            opts = {
                library = {
                    -- Load luvit types when the `vim.uv` word is found
                    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                    "${3rd}/busted/library",
                    "/usr/share/awesome/lib",
                    "/usr/share/lua",
                },
            },
        },
    },
    config = function()
        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities     = require('blink.cmp').get_lsp_capabilities()
        local servers          = {
            clangd = {},
            lua_ls = {
                -- cmd = { ... },
                -- filetypes = { ... },
                -- capabilities = {},
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
        }
        local ensure_installed = vim.tbl_keys(servers)
        vim.list_extend(ensure_installed, {
            'stylua', -- Used to format Lua code
        })
        require('mason').setup()
        require('mason-tool-installer').setup { ensure_installed = ensure_installed, }
        require('mason-lspconfig').setup({
            ensure_installed = {},
            automatic_installation = false,
            handlers = {
                ---@type fun(server_name: string)
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
                    -- server.on_attach = OnAttachLsp
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        })
    end
}
