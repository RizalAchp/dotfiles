return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
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
