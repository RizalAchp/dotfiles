return {
    'folke/trouble.nvim',
    opts = {
        fold_open = "v",
        fold_closed = ">",
        indent_lines = true,
        use_diagnostic_signs = "true",
    },
    cond = not vim.g.vscode,
    lazy = true,
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle focus=true<cr>",
            desc = "TROUBLE: Diagnostics",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
            desc = "TROUBLE: Buffer Diagnostics",
        },
        {
            "<leader>xs",
            "<cmd>Trouble symbols toggle focus=true<cr>",
            desc = "TROUBLE: Symbols)",
        },
        {
            "<leader>xl",
            "<cmd>Trouble lsp toggle focus=true win.position=right<cr>",
            desc = "TROUBLE: LSP Definitions / references / ...",
        },
        {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "TROUBLE: Location List",
        },
        {
            "<leader>xq",
            "<cmd>Trouble qflist toggle focus=true<cr>",
            desc = "TROUBLE: Quickfix List",
        },
    },
}
