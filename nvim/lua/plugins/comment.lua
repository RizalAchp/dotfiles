---@type LazySpec
return {
    'numToStr/Comment.nvim',
    -- -@type CommentConfig
    opts = {
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            line = '<M-/>',
            block = '<M-c>b',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            line = '<M-/>',
            block = '<M-c>b',
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = '<leader>ck',
            ---Add comment on the line below
            below = '<leader>cj',
            ---Add comment at the end of line
            eol = '<leader>cA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            basic = true,
            extra = true,
        },

        ---@diagnostic disable: assign-type-mismatch
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
        ---@diagnostic enable
    },
}


--[[ return {

    'b3nj5m1n/kommentary',
    config = function(_)
        require('kommentary.config').configure_language("rust", {
            prefer_single_line_comments = true,
        })
        vim.keymap.set("n", "<M-/>", "<Plug>kommentary_line_increase",
            { desc = "KOMMENTARY: add comments on cursor position", noremap = true, });
        vim.keymap.set("x", "<M-/>", "<Plug>kommentary_visual_increase",
            { desc = "KOMMENTARY: decrese comments on cursor position on visual mode", noremap = true, })

        vim.keymap.set("n", "<M-d>", "<Plug>kommentary_line_decrease",
            { desc = "KOMMENTARY: add comments on line", noremap = true, })
        vim.keymap.set("x", "<M-d>", "<Plug>kommentary_visual_decrease",
            { desc = "KOMMENTARY: add comments on position", noremap = true, })
    end
} ]]
