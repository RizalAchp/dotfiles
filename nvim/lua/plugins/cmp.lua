return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        { 'rafamadriz/friendly-snippets' },
        { 'saadparwaiz1/cmp_luasnip' },

        -- Adds LSP completion capabilities
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-nvim-lua' },
        -- { 'hrsh7th/cmp-calc' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-vsnip' },
        { 'hrsh7th/vim-vsnip' },
        { 'honza/vim-snippets' },
        {
            'saghen/blink.compat',
            -- use v2.* for blink.cmp v1.*
            version = '2.*',
            -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
            lazy = true,
            -- make sure to set opts so that lazy.nvim calls blink.compat's setup
            opts = {},
        },
        { 
            'saghen/blink.cmp',
            version = '1.*',
        },
        -- Snippet Engine & its associated nvim-cmp source
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            dependencies = {
                -- Adds a number of user-friendly snippets
                { "rafamadriz/friendly-snippets" },
                { "benfowler/telescope-luasnip.nvim" },
            },
            config = function(_, opts)
                local ls = require("luasnip");
                if opts then ls.config.setup(opts) end
                vim.tbl_map(
                    function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
                    { "vscode", "snipmate", "lua" }
                )
                ls.filetype_extend("all", { "_" })
                -- friendly-snippets - enable standardized comments snippets
                ls.filetype_extend("typescript", { "tsdoc" })
                ls.filetype_extend("javascript", { "jsdoc" })
                ls.filetype_extend("lua", { "luadoc" })
                ls.filetype_extend("python", { "pydoc" })
                ls.filetype_extend("rust", { "rustdoc" })
                ls.filetype_extend("cs", { "csharpdoc" })
                ls.filetype_extend("java", { "javadoc" })
                ls.filetype_extend("c", { "cdoc" })
                ls.filetype_extend("cpp", { "cppdoc" })
                ls.filetype_extend("php", { "phpdoc" })
                ls.filetype_extend("kotlin", { "kdoc" })
                ls.filetype_extend("ruby", { "rdoc" })
                ls.filetype_extend("sh", { "shelldoc" })
            end,
        },

    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require('luasnip');

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_document_symbol' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'nvim_lua' },
                { name = 'path' },
                { name = 'luasnip' },
                { name = 'vsnip' }, -- For vsnip users.
                {
                    name = "buffer",
                    option = {
                        keyword_pattern = [[\k\+]],
                        get_bufnrs = function()
                            local bufs = {}
                            for _, win in ipairs(vim.api.nvim_list_wins()) do
                                bufs[vim.api.nvim_win_get_buf(win)] = true
                            end
                            return vim.tbl_keys(bufs)
                        end
                    }
                },
                { name = "crates" },
            }),
            formatting = {
                expandable_indicator = true,
                fields = { 'menu', 'abbr', 'kind' },
                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = 'λ',
                        vsnip = '⋗',
                        buffer = 'Ω',
                        path = '🖫',
                    }
                    item.menu = menu_icon[entry.source.name]
                    return item
                end,
            },
        })
    end
}
