---@module 'lazy'
---@type LazySpec[]
return {
    -- { 'nvimtools/none-ls.nvim' },
    {
        'norcalli/nvim-colorizer.lua',
        cond = not vim.g.vscode,
        lazy = true,
        cmd = {
            'ColorizerAttachToBuffer',
            'ColorizerToggle',
            'ColorizerDetachFromBuffer',
            'ColorizerReloadAllBuffer',
        }
    },
    {
        'mbbill/undotree',
        lazy = true,
        cond = not vim.g.vscode,
        cmd = {
            'UndotreeFocus',
            'UndotreeHide',
            'UndotreePersistUndo',
            'UndotreeShow',
            'UndotreeToggle',
        }
    },
    -- {
    --     'MeanderingProgrammer/render-markdown.nvim',
    --     dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    --     lazy = true,
    --     cmd = "RenderMarkdown",
    --     ---@module 'render-markdown'
    --     ---@type render.md.UserConfig
    --     opts = {},
    -- },

    -- install with yarn or npm
    {
        "iamcco/markdown-preview.nvim",
        lazy = true,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        cond = not vim.g.vscode,
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    -- mini
    -- { 'echasnovski/mini.pairs', version = '*', opts = {} },
    -- {
    --     'echasnovski/mini.align',
    --     version = '*',
    --     opts = {
    --         mappings = {
    --             start = '<leader>a',
    --             start_with_preview = '<leader>A',
    --         }
    --     },
    -- },
    {
        'Vonr/align.nvim',
        branch = "master",
        lazy = true,
        init = function()
            local function m(mode, key, cmd, desc)
                local opts = { noremap = true, silent = true, desc = desc }
                vim.keymap.set(mode, key, cmd, opts)
            end

            -- Aligns to 1 character
            m('x', '<leader>aa', function() require('align').align_to_char({ preview = true, length = 1, }) end,
                "ALIGN: align 1 character")
            -- Aligns to 2 characters with previews
            m('x', '<leader>ad', function() require('align').align_to_char({ preview = true, length = 2, }) end,
                'ALIGN: align to 2 characters')
            -- Aligns to a string with previews
            m('x', '<leader>aw', function() require('align').align_to_string({ preview = true, regex = false, }) end,
                'ALIGN: align to a string')
            -- Aligns to a Vim regex with previews
            m('x', '<leader>ar', function() require 'align'.align_to_string({ preview = true, regex = true, }) end,
                'ALIGN: align to a vim regex')

            -- align a paragraph to a string with previews
            m(
                'n',
                '<leader>agw',
                function()
                    local a = require('align')
                    a.operator(a.align_to_string, { regex = false, preview = true, })
                end,
                'ALIGN: align a paragraph to a string'
            )

            -- align a paragraph to 1 character
            m(
                'n',
                '<leader>aga',
                function()
                    local a = require('align')
                    a.operator(a.align_to_char)
                end,
                'ALIGN: align a paragraph to 1 character'
            )
        end
    }
}
