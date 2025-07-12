---@module 'lazy'
---@type LazySpec
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    cond = not vim.g.vscode,

    ---@module 'ibl'
    ---@type ibl.config
    opts = {
        indent = {
            highlight = {
                "CursorColumn",
                "Whitespace",
            },
        },
        whitespace = {
            highlight = {
                "CursorColumn",
                "Whitespace",
            },
            remove_blankline_trail = false,
        },
        scope = { enabled = false },
    },
}
