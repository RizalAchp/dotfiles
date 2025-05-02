---@type LazySpec[]
return {
    -- { 'nvimtools/none-ls.nvim' },
    {
        'norcalli/nvim-colorizer.lua',
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
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    -- mini
    -- { 'echasnovski/mini.pairs', version = '*', opts = {} },
    {
        'echasnovski/mini.align',
        version = '*',
        opts = {
            mappings = {
                start = '<leader>a',
                start_with_preview = '<leader>A',
            }
        },
    },
}
