return {
    'folke/which-key.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
    -- event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    cond = not vim.g.vscode,
    event = "VeryLazy",
    ---@type wk.Opts
    opts = {
        preset = "helix",
        delay = 500,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<C-?>",
            function() require("which-key").show() end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
