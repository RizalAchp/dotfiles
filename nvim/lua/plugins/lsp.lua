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

        {
            'folke/neodev.nvim',
            opts = {},
        },
    },
    config = function()
        -- Setup neovim lua configuration
        require('neodev').setup()
        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        local servers = {
            clangd = {},
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        }
        require('mason').setup()
        require('mason-tool-installer').setup {
            ensure_installed = vim.tbl_keys(servers),
            auto_update = true,
        }

        require('mason-lspconfig').setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = false,
            handlers = {
                ---@type fun(server_name: string)
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
                    server.on_attach = OnAttachLsp
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        })
    end
}
